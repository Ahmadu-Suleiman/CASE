import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    CommunityMember member = Provider.of<CommunityMember>(context);
    return Scaffold(
      body: Material(
        child: Center(
          child: Column(children: [
            CircleAvatar(
              backgroundImage: AssetImage(member.photoUrl),
              radius: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                await DatabaseService(uid: member.uid)
                    .updateCommunityMemberData(member);
              },
              child: const Text('Update community member information'),
            ),
            TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'First name',
                  labelText: member.firstName,
                ),
                onChanged: (value) {
                  member.firstName = value;
                }),
            TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Last name',
                  labelText: member.lastName,
                ),
                onChanged: (value) {
                  member.lastName = value;
                }),
            TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Email',
                  labelText: member.email,
                ),
                onChanged: (value) {
                  member.email = value;
                }),
            TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Phone number',
                  labelText: member.phoneNumber,
                ),
                onChanged: (value) {
                  member.phoneNumber = value;
                }),
            TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Occupation',
                  labelText: member.occupation,
                ),
                onChanged: (value) {
                  member.occupation = value;
                }),
            TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Location',
                  labelText: member.location,
                ),
                onChanged: (value) {
                  member.location = value;
                }),
            TextField(
                minLines: 4,
                maxLines: null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Bio',
                  labelText: member.bio,
                ),
                onChanged: (value) {
                  member.bio = value;
                }),
          ]),
        ),
      ),
    );
  }
}
