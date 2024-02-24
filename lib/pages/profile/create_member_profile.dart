import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/location.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  CommunityMember member = CommunityMember.empty();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<User?>();
    return isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
                backgroundColor: Style.primaryColor,
                centerTitle: true,
                title: const Text('Create profile',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                actions: [
                  IconButton.filled(
                      onPressed: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          if (member.gender != null ||
                              member.location != null) {
                            member.id = user!.uid;
                            await DatabaseMember.updateCommunityMember(member);
                          } else {
                            Utility.showSnackBar(
                                context, 'Please add gender and location');
                          }
                        }
                      },
                      icon: const Icon(Icons.save, color: Colors.white))
                ]),
            body: ListView(padding: const EdgeInsets.all(12), children: [
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
                    DropdownButton<String>(
                      value: member.gender,
                      hint: const Text('Choose your gender',
                          style: TextStyle(fontSize: 18)),
                      underline: Container(),
                      icon: Icon(Icons.arrow_drop_down,
                          color: Style.primaryColor),
                      style: TextStyle(fontSize: 18, color: Style.primaryColor),
                      onChanged: (String? newValue) {
                        setState(() => member.gender = newValue!);
                      },
                      items: <String>['Male', 'Female']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
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
