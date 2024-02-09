import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/database.dart';
import 'package:case_be_heard/services/location.dart';
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
                child: const Icon(Icons.person),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  await DatabaseService(uid: member.uid ?? user!.uid)
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'First name',
                        ),
                        initialValue: member.firstName,
                        onChanged: (value) {
                          member.firstName = value;
                        }),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Last name',
                        ),
                        initialValue: member.lastName,
                        onChanged: (value) {
                          member.lastName = value;
                        }),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                        ),
                        initialValue: member.email,
                        onChanged: (value) {
                          member.email = value;
                        }),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Phone number',
                        ),
                        initialValue: member.phoneNumber,
                        onChanged: (value) {
                          member.phoneNumber = value;
                        }),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Occupation',
                        ),
                        initialValue: member.occupation,
                        onChanged: (value) {
                          member.occupation = value;
                        }),
                    TextFormField(
                      readOnly: true,
                      validator: (val) =>
                          val!.isEmpty ? 'Supply a value' : null,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() async {
                              member.location =
                                  await LocationService.getLocation(context);
                            });
                          },
                          icon: const Icon(Icons.location_on),
                        ),
                        border: const OutlineInputBorder(),
                        hintText: 'Location',
                      ),
                      initialValue: member.location.join(','),
                    ),
                    TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        minLines: 4,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Bio',
                        ),
                        initialValue: member.bio,
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
