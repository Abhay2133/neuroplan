abstract class BaseAi {
  final String accessToken;
  const BaseAi({required this.accessToken});
  Future<Map<String, dynamic>> generate(String prompt);
}
