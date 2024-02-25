import 'package:case_be_heard/custom_widgets/settings_widget.dart';
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
        appBar: AppBar(
            title: const Text('Settings',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            centerTitle: true),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SettingsWidget(
                  icon: Icons.person,
                  text: 'Edit profile',
                  onPressed: () => context.push(Routes.editMemberProfile)),
              const Divider(),
              SettingsWidget(
                  icon: Icons.details,
                  text: 'About',
                  onPressed: () => Utility.openLink(context,
                      'https://ahmadu-suleiman.github.io/landing-page/')),
              const Divider(),
              SettingsWidget(
                  icon: Icons.phone,
                  text: 'Contact us',
                  onPressed: () =>
                      Utility.openEmailApp(context, 'ahmadumeta4.1@gmail.com')),
              const Divider(),
              SettingsWidget(
                  icon: Icons.logout,
                  text: 'Logout',
                  onPressed: () {
                    AuthService.signOut();
                    context.pop();
                  }),
              const Divider()
            ])));
  }
}
