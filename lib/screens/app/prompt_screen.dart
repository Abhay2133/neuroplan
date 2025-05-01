import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neuroplan/constants/colors.dart';
import 'package:neuroplan/utils.dart';
import 'package:neuroplan/widgets/skeleton.dart';
import 'package:neuroplan/widgets/spinner.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  bool isLoading = false;
  bool isFailed = false;
  int generateId = 0;
  final TextEditingController _controller = TextEditingController();
  dynamic data;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onStop() {
    setState(() {
      isLoading = false;
      generateId += 1;
    });
  }

  void onGenerate() {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Give a prompt first")));
      return;
    }
    int id = generateId + 1;
    setState(() {
      isLoading = true;
      isFailed = false;
      generateId = id;
    });

    Future.delayed(Duration(seconds: 1), () {
      if (generateId != id) return;
      setState(() {
        data = true;
        isLoading = false;
        isFailed = id % 2 == 0;
      });
    });
  }

  void save() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Prompt Generation",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Gap(10),
            Text("Your Idea"),
            Gap(10),
            _input(context),
            Gap(10),
            _buttonsRow(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _outputList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(BuildContext context) {
    return TextField(
      maxLines: null,
      controller: _controller,
      minLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: 'Enter your text here...',
        border: InputBorder.none, // No border
        filled: true, // Enable background color
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // No border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
          borderSide: BorderSide.none, // No border
        ),
      ),
    );
  }

  Widget _buttonsRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _generateBtn(context),
        Gap(8),
        show(isLoading, _stopBtn(context)),
        show(!isFailed && !isLoading && data != null, _saveBtn(context)),
        show(isFailed, Text("Failed to Load, try regenerating.")),
      ],
    );
  }

  Widget _stopBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColor.grey100),
      onPressed: onStop,
      child: Text("Stop", style: TextStyle(color: Color(0xFF333333))),
    );
  }

  Widget _saveBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColor.grey100),
      onPressed: save,
      child: Text(
        "Save as Project",
        style: TextStyle(color: Color(0xFF333333)),
      ),
    );
  }

  Widget _generateBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onGenerate,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            isLoading
                ? [
                  Text("Generating"),
                  Gap(12),
                  Spinner(radius: 6, strokeWidth: 3, color: Colors.white),
                ]
                : [Text(data != null ? "Regenerate" : "Generate")],
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    List<dynamic> items = List.filled(4, "");
    return ListView.separated(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Skeleton(height: 100, width: double.infinity);
      },
      separatorBuilder:
          (context, index) => SizedBox(height: 10), // spacing here
    );
  }

  Widget _outputList(BuildContext contex) {
    // return _dataList(context);
    if (!isLoading && data == null) return SizedBox();
    return isLoading ? _placeholder(context) : _dataList(context);
  }

  Widget _dataList(BuildContext context) {
    return Column(
      children: [
        Text("Main Goal", style: Theme.of(context).textTheme.headlineMedium),
        Gap(8),
        ListView.separated(
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (contex, index) {
            return _listItem(context, index + 1);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Gap(10);
          },
        ),
      ],
    );
  }

  Widget _listItem(BuildContext context, int index) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "$index. Heading",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Expanded(child: SizedBox()),
                Text(
                  "Time Required",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            Gap(10),
            Text(
              "Define project scope, features, and target audience. Research competitors and identify key functionalities. Create a rough wireframe and define the technology stack (Flutter for frontend, Node.js with Express for backend, PostgreSQL for database, Stripe for payments).",
            ),
          ],
        ),
      ),
    );
  }
}
