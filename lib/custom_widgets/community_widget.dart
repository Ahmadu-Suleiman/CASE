import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:flutter/material.dart';

class CommunityWidget extends StatelessWidget {
  final Community community;
  const CommunityWidget({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //TODO: SEND TO COMMUNITY
        },
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                          imageUrl: community.image,
                          width: double.infinity,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Icon(Icons.image),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error))),
                  Text(community.name,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    const Icon(Icons.location_on),
                    Text('${community.state} state')
                  ]),
                  Text('${community.memberIds.length} members')
                ]))));
  }
}
