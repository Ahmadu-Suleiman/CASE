import 'package:case_be_heard/custom_widgets/case_page.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/pages/create_case.dart';
import 'package:case_be_heard/services/auth.dart';
import 'package:case_be_heard/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:case_be_heard/pages/home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(StreamProvider<CommunityMember?>.value(
    initialData: null,
    value: AuthService().communityMember,
    child: MaterialApp(
      home: Wrapper(),
      routes: {
        '/create_case': (context) => const CreateCase(),
        '/case_page': (context) => const CasePage(),
      },
    ),
  ));
}
