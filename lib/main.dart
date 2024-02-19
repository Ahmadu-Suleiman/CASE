import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/auth.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Gemini.init(
      apiKey: 'AIzaSyAurd8bwkqj7UaMlsByZ_4-rDBFTPCjMSk',
      safetySettings: CaseValues.safetySettings,
      enableDebugging: true);
  runApp(const CaseApp());
}

class CaseApp extends StatelessWidget {
  const CaseApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  routerConfig: Routes.router,
                  theme: ThemeData(
                      focusColor: Style.secondaryColor,
                      hoverColor: Style.secondaryColor,
                      primaryColor: Style.primaryColor,
                      iconTheme: const IconThemeData(color: Colors.black),
                      colorScheme: ColorScheme.light(
                        background: Colors.white,
                        primary: Style.primaryColor,
                        secondary: Style.secondaryColor,
                      )),
                  darkTheme: ThemeData(
                      focusColor: Style.secondaryColor,
                      hoverColor: Style.secondaryColor,
                      primaryColor: Style.primaryColor,
                      iconTheme: const IconThemeData(
                        color: Colors.black, // Set the global color for icons
                      ),
                      colorScheme: ColorScheme.dark(
                        background: Style.colorDark,
                        secondary: Style.secondaryColor,
                      )),
                  themeMode: ThemeMode.system,
                );
              }));
        }));
  }
}
