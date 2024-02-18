import 'package:flutter_gemini/flutter_gemini.dart';

class CaseValues {
  static const investigationPending = 'Investigation pending';
  static const investigationOngoing = 'Investigation ongoing';
  static const caseSolved = 'Case solved';

  static const commentVerified = 'verified';
  static const commentUseful = 'useful';
  static const commentOthers = 'others';

  static const verifiedID = 'Identity verified';
  static const notVerfiedID = 'Identity not verified';

  static final dropdownItems = [
    investigationPending,
    investigationOngoing,
    caseSolved,
  ];
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
