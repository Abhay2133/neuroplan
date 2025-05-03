import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

Map<String, dynamic> parseRoadmapToJson(String raw) {
  // Extract the JSON part from the raw string using RegExp
  final regex = RegExp(r'```.*```',dotAll: true);
  final match = regex.firstMatch(raw);

  if (match == null) {
throw FormatException('No valid JSON found in the input.');
  }

  String jsonString = match.group(0)!;
  jsonString = jsonString.substring(3, jsonString.length - 3);

  // Decode JSON into a Dart Map
  final parsed = jsonDecode(jsonString);
  return parsed;
  // // Encode back to pretty JSON string (optional)
  // final encodedJson = const JsonEncoder.withIndent('  ').convert(parsed);

  // return encodedJson;
}
Widget show(bool isTrue, [Widget child = const SizedBox()]) {
  return isTrue ? child : SizedBox();
}

void dlog(dynamic text) {
  if (kDebugMode) {
    print(text);
  }
}


void alert(
  BuildContext context,
  String text, {
  bool copy = false,
  String title = "Alert",
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        content: Text(text),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              copy
                  ? TextButton(
                    onPressed: () async {
                      Navigator.pop(context); // Close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Copied to clipboard")),
                      );
                      await Clipboard.setData(ClipboardData(text: text));
                    },
                    child: Text(
                      "Copy",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                  : SizedBox(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                },
                child: Text(
                  "OK",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}