import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/custom_widgets/text_icon.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommunityStateWidget extends StatelessWidget {
  final String countryISO;
  final String state;
  const CommunityStateWidget(
      {super.key, required this.countryISO, required this.state});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.push(''), //TODO: stuff
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(state,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      IconText(icon: Icons.place, text: state)
                    ]))));
  }
}
