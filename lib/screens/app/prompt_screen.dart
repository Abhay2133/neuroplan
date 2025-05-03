import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neuroplan/constants/colors.dart';
import 'package:neuroplan/constants/env.dart';
import 'package:neuroplan/constants/samples.dart';
import 'package:neuroplan/services/ai/ai_factory.dart';
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
  final TextEditingController _controller = TextEditingController(
    text:
        "I want to launch a mobile app that helps people track their daily water intake, with features like reminders, progress charts, and gamification.",
  );
  dynamic data = promptResult;
  late AiFactory aiFactory;

  @override
  void initState() {
    super.initState();
    aiFactory = AiFactory(
      accessToken: ENV.accessToken,
      aiProvider: ENV.aiProvider,
    );
  }

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

  void onGenerate() async {
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

    try {
      Map<String, dynamic> output = await aiFactory.generate(_controller.text);
      setState(() {
        data = output;
      });
      dlog(data);
    } catch (e) {
      alert(context, e.toString(), title: "Failed to load results");
      setState(() {
        isFailed = true;
      });
    } finally {
      // Future.delayed(Duration(seconds: 1), () {
      if (generateId != id) return;
      setState(() {
        // data = true;
        isLoading = false;
        // isFailed = id % 2 == 0;
      });
      // });
    }
  }

  void save() {}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                : [
                  data != null
                      ? Icon(Icons.restart_alt)
                      : Icon(Icons.arrow_forward),
                  Gap(12),
                  Text(data != null ? "Regenerate" : "Generate"),
                ],
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
      separatorBuilder: (context, index) => SizedBox(height: 8), // spacing here
    );
  }

  Widget _outputList(BuildContext contex) {
    // return _dataList(context);
    if (!isLoading && data == null) return SizedBox();
    return isLoading ? _placeholder(context) : _dataList(context);
  }

  Widget _dataList(BuildContext context) {
    if (data.containsKey("error")) {
      return SizedBox(
        height: 100,
        child: Center(child: Text("${data['error']}")),
      );
    }
    List<dynamic> tasks = data["tasks"] ?? [];
    return Column(
      children: [
        Gap(12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(
                data["goal"] ?? "Main Goal",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Expanded(child: SizedBox()),
              Text(
                "${tasks.length} Task${tasks.length > 1 ? 's' : ''}",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        Gap(16),
        ListView.separated(
          shrinkWrap: true,
          itemCount: tasks.length,
          itemBuilder: (contex, index) {
            Map<String, dynamic> item = tasks[index];
            String title = item["heading"] ?? "";
            String description = item["description"] ?? "";
            String duration = item["duration"] ?? "";
            return _listItem(context, title, description, duration);
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 4);
          },
        ),
      ],
    );
  }

  Widget _listItem(
    BuildContext context,
    String title,
    String description,
    String duration,
  ) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                Expanded(child: SizedBox()),
                Text(duration, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            Gap(10),
            Text(description),
          ],
        ),
      ),
    );
  }
}
