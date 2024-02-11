import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
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
  CommunityMember member = CommunityMember.empty();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    member = Provider.of<CommunityMember?>(context) ?? member;
    return isLoading
        ? const Loading()
        : Scaffold(
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
                        await DatabaseMember(uid: member.uid ?? user!.uid)
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
                          TextButton.icon(
                            onPressed: () async {
                              setState(() => isLoading = true);
                              member.location =
                                  await LocationService.getLocation(context);
                              setState(() => isLoading = false);
                            },
                            icon: const Icon(Icons.location_on),
                            label: Text(
                              member.location.isEmpty
                                  ? 'Choose your location'
                                  : member.location.join(','),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ),
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
