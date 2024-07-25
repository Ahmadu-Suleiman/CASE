import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/auth.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/shared/gemini_help.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load();
  Gemini.init(
      apiKey: dotenv.env['GEMINI_API_KEY']!,
      safetySettings: GeminiHelp.safetySettings,
      enableDebugging: true);
  runApp(const CaseApp());
}

class CaseApp extends StatelessWidget {
  const CaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme lightColorScheme =
        ColorScheme.fromSeed(seedColor: Style.mainColor);
    ColorScheme darkColorScheme = ColorScheme.fromSeed(
        seedColor: Style.mainColorDark, brightness: Brightness.dark);
    return StreamProvider<User?>.value(
        value: AuthService().communityMember,
        initialData: null,
        child: Consumer<User?>(builder: (context, user, child) {
          return StreamProvider<CommunityMember?>.value(
              value: DatabaseMember.getMember(user?.uid),
              initialData: null,
              child: Consumer<CommunityMember?>(
                  builder: (context, communityMember, child) {
                return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    routerConfig: Routes.router,
                    theme: ThemeData(
                        colorScheme: lightColorScheme, fontFamily: 'Lato'),
                    darkTheme: ThemeData(
                        colorScheme: darkColorScheme, fontFamily: 'Lato'));
              }));
        }));
  }
}
