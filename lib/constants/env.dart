import 'package:flutter_dotenv/flutter_dotenv.dart';

class ENV {
  static final String accessToken = dotenv.env["ACCESS_TOKEN"] ?? "";
  static final String aiProvider = dotenv.env["AI_PROVIDER"] ?? "";
}