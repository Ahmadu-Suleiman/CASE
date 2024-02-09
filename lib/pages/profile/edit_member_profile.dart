import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/database.dart';
import 'package:case_be_heard/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    CommunityMember member =
        Provider.of<CommunityMember?>(context) ?? CommunityMember.empty();
    return Scaffold(
      body: Material(
        child: Center(
          child: Column(children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile_image');
              },
              child: CircleAvatar(
                backgroundImage: Utility.getProfileImage(member.photoUrl),
                radius: 50,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  await DatabaseService(uid: member!.uid ?? user!.uid)
                      .updateCommunityMemberData(member);
                }
              },
              child: const Text('Update community member information'),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'First name',
                          labelText: member.firstName,
                        ),
                        onChanged: (value) {
                          member.firstName = value;
                        }),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Last name',
                          labelText: member.lastName,
                        ),
                        onChanged: (value) {
                          member.lastName = value;
                        }),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Email',
                          labelText: member.email,
                        ),
                        onChanged: (value) {
                          member.email = value;
                        }),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Phone number',
                          labelText: member.phoneNumber,
                        ),
                        onChanged: (value) {
                          member.phoneNumber = value;
                        }),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Occupation',
                          labelText: member.occupation,
                        ),
                        onChanged: (value) {
                          member.occupation = value;
                        }),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Location',
                          labelText: member.location,
                        ),
                        onChanged: (value) {
                          member.location = value;
                        }),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
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
                  ],
                )),
          ]),
        ),
      ),
    );
  }
}
