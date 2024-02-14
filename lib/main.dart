import 'package:case_be_heard/pages/case_pages/case_page.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/pages/case_pages/case_view_photo.dart';
import 'package:case_be_heard/pages/case_pages/create_case.dart';
import 'package:case_be_heard/pages/profile/edit_member_profile.dart';
import 'package:case_be_heard/pages/profile/member_profile.dart';
import 'package:case_be_heard/pages/profile/profile_image.dart';
import 'package:case_be_heard/services/auth.dart';
import 'package:case_be_heard/pages/wrapper.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
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
                Routes.routeCreateCase: (context) => const CreateCase(),
                Routes.routeCasePage: (context) => const CasePage(),
                Routes.routeMemberProfile: (context) => const Profile(),
                Routes.routeEditMemberProfile: (context) => const EditProfile(),
                Routes.routeProfileImage: (context) => const ProfileImage(),
                Routes.routeCasePhoto: (context) => const CasePhotoWidget(),
              },
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
            ));
      },
    );
  }
}
