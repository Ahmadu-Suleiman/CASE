import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiHelp {
  static final safetySettings = [
    SafetySetting(
      category: SafetyCategory.harassment,
      threshold: SafetyThreshold.blockNone,
    ),
    SafetySetting(
      category: SafetyCategory.hateSpeech,
      threshold: SafetyThreshold.blockNone,
    ),
    SafetySetting(
      category: SafetyCategory.dangerous,
      threshold: SafetyThreshold.blockNone,
    ),
    SafetySetting(
      category: SafetyCategory.sexuallyExplicit,
      threshold: SafetyThreshold.blockNone,
    )
  ];
}
