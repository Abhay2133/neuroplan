import 'package:neuroplan/services/ai/base_ai.dart';
import 'package:neuroplan/services/ai/groq.dart';

class AiFactory {
  late BaseAi _baseAi;
  AiFactory({required String accessToken,required String aiProvider}) {
    if (aiProvider == "groq") {
      _baseAi = Groq(accessToken: accessToken);
    } else {
      throw UnimplementedError();
    }
  }

  Future<Map<String, dynamic>> generate(String prompt) async {
    Map<String, dynamic> output = await _baseAi.generate(prompt);
    return output;
  }
}
