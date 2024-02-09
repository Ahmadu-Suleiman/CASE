import 'package:case_be_heard/pages/authenticate/authenticate.dart';
import 'package:case_be_heard/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return user == null ? Authenticate() : const HomeWidget();
  }
}
