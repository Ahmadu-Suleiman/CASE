import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/pages/authenticate/authenticate.dart';
import 'package:case_be_heard/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final communityMember = Provider.of<CommunityMember?>(context);

    // return either the Home or Authenticate widget
    return communityMember == null ? Authenticate() : const HomeWidget();
  }
}
