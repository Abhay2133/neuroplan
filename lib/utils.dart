import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

String generateHash(String input) {
  // Convert the input string to bytes
  var bytes = utf8.encode(input);

  // Generate the hash using SHA-256
  var hash = sha256.convert(bytes);

  // Return the first 16 characters of the hash
  return hash.toString().substring(0, 16);
}

void main() {
  String input = 'YourInputStringHere';
  String hash = generateHash(input);
  print('Generated Hash: $hash');
}

Map<String, dynamic> parseRoadmapToJson(String raw) {
  // Extract the JSON part from the raw string using RegExp
  final regex = RegExp(r'```.*```', dotAll: true);
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
  VoidCallback? onOk,
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
                        SnackBar(content: Text("Copied to clipboard"), behavior: SnackBarBehavior.floating, width: 400,),
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
                  if (onOk != null) onOk();
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

String timeElapsed(String utcDateTime) {
  // Parse the UTC string to DateTime
  DateTime dateTime = DateTime.parse(utcDateTime).toLocal();
  DateTime now = DateTime.now();

  Duration difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    return '${(difference.inDays / 365).floor()} year(s) ago';
  } else if (difference.inDays > 30) {
    return '${(difference.inDays / 30).floor()} month(s) ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} day(s) ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour(s) ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute(s) ago';
  } else {
    return '${difference.inSeconds} second(s) ago';
  }
}

String timeAgoFromTimestamp(Timestamp timestamp) {
  final now = DateTime.now();
  final time = timestamp.toDate();
  final difference = now.difference(time);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} second${difference.inSeconds == 1 ? '' : 's'} ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks week${weeks == 1 ? '' : 's'} ago';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months == 1 ? '' : 's'} ago';
  } else {
    final years = (difference.inDays / 365).floor();
    return '$years year${years == 1 ? '' : 's'} ago';
  }
}

Future<String?> showTextInputDialog({
  required BuildContext context,
  required String title,
  String hintText = '',
  String submitLabel = 'Submit',
  String cancelLabel = 'Cancel',
}) async {
  final TextEditingController controller = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hintText),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // cancel
            child: Text(cancelLabel),
          ),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(context, text);
              }
            },
            child: Text(submitLabel),
          ),
        ],
      );
    },
  );
}
