import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/pages/authenticate/authenticate.dart';
import 'package:case_be_heard/pages/home.dart';
import 'package:case_be_heard/pages/profile/edit_member_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    final communityMember = Provider.of<CommunityMember?>(context);
    return user == null
        ? const Authenticate()
        : communityMember == null
            ? const EditProfile()
            : const HomeWidget();
  }
}
