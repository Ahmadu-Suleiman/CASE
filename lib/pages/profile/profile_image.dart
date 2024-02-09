import 'package:case_be_heard/models/community_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ProfileImageState extends StatefulWidget {
  const _ProfileImageState({super.key});

  @override
  State<_ProfileImageState> createState() => __ProfileImageStateState();
}

class __ProfileImageStateState extends State<_ProfileImageState> {
  @override
  Widget build(BuildContext context) {
    CommunityMember member = Provider.of<CommunityMember>(context);
  String? photoUrl=member.photoUrl;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: member.photoUrl != null
      ? NetworkImage(member.photoUrl!)
      : const AssetImage('assets/person.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child:  Align(
          alignment: Alignment.bottomCenter,
          child:TextButton.icon(
                  onPressed: () async {
                    addPhotos();
                  },
                  icon: const Icon(Icons.image),
                  label: const Text(
                    'Change image',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
