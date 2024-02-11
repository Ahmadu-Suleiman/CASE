import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    CommunityMember member =
        Provider.of<CommunityMember?>(context) ?? CommunityMember.empty();
    if (user != null) {
      var m = DatabaseMember(uid: user.uid).member;
      print(m);
    }
    return isLoading
        ? const Loading()
        : Scaffold(
            body: Material(
              child: Center(
                child: Column(children: [
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
