import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/pages/authenticate/authenticate.dart';
import 'package:case_be_heard/pages/home.dart';
import 'package:case_be_heard/pages/profile/create_member_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<User?, CommunityMember?>(
        builder: (context, user, communityMember, child) {
      if (user == null) {
        return const Authenticate();
      } else if (communityMember == null) {
        return const CreateProfile();
      } else {
        return const HomePage();
      }
    });
  }
}
