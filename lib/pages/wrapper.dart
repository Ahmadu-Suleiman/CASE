import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/pages/authenticate/authenticate.dart';
import 'package:case_be_heard/pages/home.dart';
import 'package:case_be_heard/pages/profile/create_member_profile.dart';
import 'package:case_be_heard/services/auth.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().communityMember,
      initialData: null,
      child: Consumer<User?>(
        builder: (context, user, child) {
          if (user == null) {
            return const Authenticate();
          } else {
            return StreamProvider<CommunityMember?>.value(
              value: DatabaseMember(uid: user.uid).member,
              initialData: null,
              child: Consumer<CommunityMember?>(
                builder: (context, communityMember, child) {
                  if (communityMember == null) {
                    return const CreateProfile();
                  } else {
                    return const HomeWidget();
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}
