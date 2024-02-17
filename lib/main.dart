import 'package:case_be_heard/shared/case_helper.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Gemini.init(
      apiKey: 'AIzaSyAurd8bwkqj7UaMlsByZ_4-rDBFTPCjMSk',
      safetySettings: CaseHelper.safetySettings,
      enableDebugging: true);
  runApp(const CaseApp());
}

class CaseApp extends StatelessWidget {
  const CaseApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routes.router,
      theme: ThemeData(
        focusColor: Style.secondaryColor,
        hoverColor: Style.secondaryColor,
        primaryColor: Style.primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.black, // Set the global color for icons
        ),
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: Colors.white,
          accentColor: Style.primaryColor,
        ),
      ),
    );
  }
}
