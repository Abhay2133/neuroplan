import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class PromptScreen extends StatelessWidget {
  const PromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Prompt Generation",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Gap(10),
          Text("User Idea"),
          Gap(10),
          _input(context),
          Gap(10),
          _buttonRow(context),
          _outputList(context),
        ],
      ),
    );
  }

  Widget _input(BuildContext context) {
    return TextField(
      maxLines: null,
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

  Widget _buttonRow(BuildContext context) {
    return Row(
      children: [ElevatedButton(onPressed: () {}, child: Text("Generate"))],
    );
  }

  Widget _outputList(BuildContext context) {
    return ListView(children: [_listItem(context)]);
  }

  Widget _listItem(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: Colors.red,
        highlightColor: Colors.yellow,
        child: Text(
          'Shimmer',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
