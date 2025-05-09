abstract class BaseAi {
  final String accessToken;
  const BaseAi({required this.accessToken});
  Future<Map<String, dynamic>> generate(String prompt);
}

class InvalidApiKey implements Exception {
  final String message;
  InvalidApiKey(this.message);

  @override
  String toString() => 'IAK error : $message';
}
