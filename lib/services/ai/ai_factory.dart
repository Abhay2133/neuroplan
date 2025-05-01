import 'package:neuroplan/services/ai/base_ai.dart';

class AiFactory {
  final BaseAi baseAi;
  AiFactory(B, this.baseAi);

  Future<Map<String, dynamic>> generate() async {
    Map<String, dynamic> output = await baseAi.generate();
    return output;
  }
}
