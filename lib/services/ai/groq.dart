import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:neuroplan/services/ai/base_ai.dart';
import 'package:neuroplan/utils.dart';

class Groq extends BaseAi {
  Groq({required super.accessToken});

  @override
  Future<Map<String, dynamic>> generate(String userPrompt) async {
    final url = Uri.parse("https://api.groq.com/openai/v1/chat/completions");
    try {
      String prompt = createPrompt(userPrompt);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // if needed
        },
        body: jsonEncode({
          "model": "llama3-70b-8192",
          "messages": [
            {"role": "user", "content": prompt},
          ],
        }),
      );

      if (response.statusCode == 401) {
        throw InvalidApiKey("INVALID GROQ API KEY");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String content = data["choices"][0]["message"]["content"];
        return jsonDecode(content);
      } else {
        dlog('HTTP Error: ${response.statusCode}');
        throw Exception(
          "${response.statusCode} : Failed to load prompt response : ${response.body}",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  String createPrompt(String userPrompt) {
    return '''
You are a roadmap generator.

Based on the user's goal described in natural language, generate a roadmap in **valid JSON format only**.

Requirements:
 - The output must be **only the JSON string**—no explanations, no preamble, no trailing text.
 - The JSON must match one of the two structures exactly:

**Success structure:**
{
  "goal": "Overall goal or project",
  "tasks": [
    {
      "heading": "Title of the task",
      "description": "A clear explanation of what the task involves",
      "duration": "Estimated time to complete this task, e.g., '2 days', '1 week'"
    }
  ]
}

**Error structure:**
{
  "error": "Show proper error message with reason"
}

 - Only return the JSON string, no Markdown or extra formatting.
 - All values must be strings.
 - Return an error if the prompt is vague or non-goal-oriented.
 - Do not omit brackets.
 - always generate minimum 5 number of steps.
 - Do not omit values of these keys also.
 - The output must be strictly valid JSON.
 - Do not omit 'heading' as key.
 - Do not omit 'description' as key.
 - Do not omit 'duration' as key.

Example user prompt:
"I want to build a mobile app that helps users manage their daily habits."

Now generate the appropriate JSON based on the following user prompt:
"$userPrompt"
''';
  }
}
