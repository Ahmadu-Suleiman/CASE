import 'package:case_be_heard/custom_widgets/settings_widget.dart';
import 'package:case_be_heard/custom_widgets/text_icon.dart';
import 'package:case_be_heard/services/auth.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Column(
        children: [
          SettingsWidget(
              icon: Icons.person,
              iconSize: 20,
              text: 'Edit profile',
              fontSize: 20,
              onPressed: () => context.push(Routes.editMemberProfile)),
          SettingsWidget(
              icon: Icons.details,
              iconSize: 20,
              text: 'About',
              fontSize: 20,
              onPressed: () => context.push(Routes.editMemberProfile)),
          SettingsWidget(
              icon: Icons.phone,
              iconSize: 20,
              text: 'Contact us',
              fontSize: 20,
              onPressed: () =>
                  Utility.openEmailApp(context, 'ahmadumeta4.1@gmail.com')),
          SettingsWidget(
              icon: Icons.logout,
              iconSize: 20,
              text: 'Logout',
              fontSize: 20,
              onPressed: () => AuthService.signOut()),
        ],
      ),
    );
  }
}
