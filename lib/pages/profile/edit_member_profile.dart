import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/location.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  String address = '';

  @override
  Widget build(BuildContext context) {
    member = context.watch<CommunityMember>();
    return FutureBuilder(
        future: LocationService.getLocationAddress(member.location),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            address = snapshot.data!;
            return isLoading
                ? const Loading()
                : Scaffold(
                    body: SafeArea(
                        child: Center(
                            child: ListView(children: [
                    CachedAvatar(
                        url: member.photoUrl,
                        size: 60,
                        onPressed: () => context.push(Routes.profileImage)),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState != null &&
                              _formKey.currentState!.validate()) {
                            await DatabaseMember.updateCommunityMemberData(
                                member);
                            if (context.mounted) {
                              Utility.showSnackBar(
                                  context, 'information updated');
                            }
                          }
                        },
                        child:
                            const Text('Update community member information')),
                    Form(
                        key: _formKey,
                        child: Column(children: [
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
                                    await LocationService.getCurrentLocation(
                                        context);
                                if (context.mounted) {
                                  address =
                                      await LocationService.getLocationAddress(
                                          context: context, member.location);
                                }
                                setState(() => isLoading = false);
                              },
                              icon: const Icon(Icons.location_on),
                              label: Text(
                                  address.isEmpty
                                      ? 'Choose your location'
                                      : address,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ))),
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
                              })
                        ]))
                  ]))));
          } else {
            return const Loading();
          }
        });
  }
}
