import 'package:case_be_heard/pages/case_page.dart';
import 'package:case_be_heard/pages/create_case.dart';
import 'package:flutter/material.dart';
import 'package:case_be_heard/pages/home.dart';

void main() {
  runApp(MaterialApp(
    home: const HomeWidget(),
    routes: {
      '/create_case': (context) => const CreateCase(),
      '/case_page': (context) => const CasePage()
    },
  ));
}
