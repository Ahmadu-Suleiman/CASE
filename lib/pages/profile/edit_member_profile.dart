import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/location.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    member = context.watch<CommunityMember>().copyWith();
    return isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
               
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white), // Specify the color here
                  onPressed: () => Navigator.of(context).pop(),
                ),
                centerTitle: true,
                title: const Text('Update profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                actions: [
                  IconButton.filled(
                      color: Colors.white,
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          await DatabaseMember.updateCommunityMember(member);
                          if (context.mounted) {
                            Utility.showSnackBar(
                                context, 'Information updated');
                          }
                        }
                      },
                      icon: const Icon(Icons.save))
                ]),
            body: ListView(padding: const EdgeInsets.all(12), children: [
              Center(
                  child: Stack(children: [
                CachedAvatar(
                    url: member.photoUrl,
                    size: 60,
                    onPressed: () => context.push(Routes.profileImage)),
                Positioned(
                    bottom: 10,
                    right: 90,
                    child: IconButton.filled(
                        onPressed: () => context.push(Routes.profileImage),
                        icon: const Icon(Icons.create, color: Colors.white)))
              ])),
              const SizedBox(height: 20.0),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    const SizedBox(height: 20.0),
                    TextFormField(
                        style: const TextStyle(fontSize: 18),
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: Style.descriptiveDecoration('First name'),
                        initialValue: member.firstName,
                        onChanged: (value) {
                          member.firstName = value;
                        }),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        style: const TextStyle(fontSize: 18),
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: Style.descriptiveDecoration('Last name'),
                        initialValue: member.lastName,
                        onChanged: (value) {
                          member.lastName = value;
                        }),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        style: const TextStyle(fontSize: 18),
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration:
                            Style.descriptiveDecoration('Email address'),
                        initialValue: member.email,
                        onChanged: (value) {
                          member.email = value;
                        }),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        style: const TextStyle(fontSize: 18),
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: Style.descriptiveDecoration('Phone number'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        initialValue: member.phoneNumber,
                        onChanged: (value) {
                          member.phoneNumber = value;
                        }),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        style: const TextStyle(fontSize: 18),
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        decoration: Style.descriptiveDecoration('Occupation'),
                        initialValue: member.occupation,
                        onChanged: (value) {
                          member.occupation = value;
                        }),
                    const SizedBox(height: 20.0),
                    TextButton.icon(
                        onPressed: () async {
                          setState(() => isLoading = true);
                          member.location =
                              await LocationService.getCurrentLocation(context);
                          if (context.mounted) {
                            member.address =
                                await LocationService.getLocationAddressString(
                                    context: context, member.location);
                          }
                          setState(() => isLoading = false);
                        },
                        icon: const Icon(Icons.location_on),
                        label: Text(
                            member.address.isEmpty
                                ? 'Choose your location'
                                : member.address,
                            style: const TextStyle(fontSize: 18))),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        style: const TextStyle(fontSize: 18),
                        validator: (val) =>
                            val!.isEmpty ? 'Supply a value' : null,
                        minLines: 4,
                        maxLines: null,
                        decoration: Style.descriptiveDecoration('Bio'),
                        initialValue: member.bio,
                        onChanged: (value) {
                          member.bio = value;
                        })
                  ]))
            ]));
  }
}
