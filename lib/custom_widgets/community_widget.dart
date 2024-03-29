import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/custom_widgets/text_icon.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:flutter/material.dart';

class CommunityWidget extends StatelessWidget {
  final Community community;
  final Function onChoose;
  const CommunityWidget(
      {super.key, required this.community, required this.onChoose});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onChoose(),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                            imageUrl: community.image,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const Icon(Icons.image),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error))),
                  ),
                  const SizedBox(height: 8),
                  Text(community.name,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.people),
                              Text(community.memberIds.length.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                            ]),
                        IconText(
                            icon: Icons.place,
                            iconSize: 14,
                            text: community.state,
                            fontSize: 16)
                      ])
                ]))));
  }
}
