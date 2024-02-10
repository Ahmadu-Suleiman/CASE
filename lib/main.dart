import 'package:case_be_heard/pages/case_pages/case_page.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/pages/case_pages/create_case.dart';
import 'package:case_be_heard/pages/profile/edit_member_profile.dart';
import 'package:case_be_heard/pages/profile/member_profile.dart';
import 'package:case_be_heard/pages/profile/profile_image.dart';
import 'package:case_be_heard/services/auth.dart';
import 'package:case_be_heard/pages/wrapper.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const StartWidget());
}

class StartWidget extends StatelessWidget {
  const StartWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      initialData: null,
      value: AuthService().communityMember,
      builder: (context, child) {
        return StreamProvider<CommunityMember?>.value(
            initialData: null,
            value: DatabaseMember(uid: Provider.of<User?>(context)?.uid).member,
            child: MaterialApp(
              home: const Wrapper(),
              routes: {
                '/create_case': (context) => const CreateCase(),
                '/case_page': (context) => const CasePage(),
                '/member_profile': (context) => const Profile(),
                '/edit_member_profile': (context) => const EditProfile(),
                '/profile_image': (context) => const ProfileImage(),
              },
              theme: ThemeData(
                focusColor: secondaryColor,
                hoverColor: secondaryColor,
                primaryColor: primaryColor,
                iconTheme: const IconThemeData(
                  color: Colors.black, // Set the global color for icons
                ),
                colorScheme: ColorScheme.fromSwatch(
                  backgroundColor: Colors.white,
                  accentColor: primaryColor,
                ),
              ),
            ));
      },
    );
  }
}
