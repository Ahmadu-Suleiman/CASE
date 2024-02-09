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

    return StreamBuilder<CommunityMember>(
        stream: DatabaseService(uid: member.uid).member,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            member = snapshot.data ?? member;
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First name',
                        ),
                        onChanged: (value) {
                          member.firstName = value;
                        }),
                    TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last name',
                        ),
                        onChanged: (value) {
                          member.firstName = value;
                        }),
                    TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        onChanged: (value) {
                          member.firstName = value;
                        }),
                    TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone number',
                        ),
                        onChanged: (value) {
                          member.firstName = value;
                        }),
                    TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Occupation',
                        ),
                        onChanged: (value) {
                          member.firstName = value;
                        }),
                    TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Location',
                        ),
                        onChanged: (value) {
                          member.firstName = value;
                        }),
                    TextField(
                        minLines: 4,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Bio',
                        ),
                        onChanged: (value) {
                          member.firstName = value;
                        }),
                  ]),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
