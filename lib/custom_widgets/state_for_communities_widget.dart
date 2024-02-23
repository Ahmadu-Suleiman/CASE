import 'package:case_be_heard/custom_widgets/text_icon.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StatesForCommunitiesWidget extends StatelessWidget {
  final String countryISO;
  final String state;
  const StatesForCommunitiesWidget(
      {super.key, required this.countryISO, required this.state});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () =>
            context.push('${Routes.communitiesFromState}/$state/$countryISO'),
        child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Column(children: [
              Text(state, // GestureDetector only works if thistext is pressd
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              IconText(
                  icon: Icons.place,
                  iconSize: 14,
                  text: countryISO,
                  fontSize: 14),
              const Divider()
            ])));
  }
}
