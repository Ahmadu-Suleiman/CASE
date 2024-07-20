import 'dart:io';

import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:case_be_heard/shared/community_helper.dart';
// import 'package:case_be_heard/shared/style.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCommunityWidget extends StatefulWidget {
  const CreateCommunityWidget({super.key});

  @override
  State<CreateCommunityWidget> createState() => _CreateCommunityWidgetState();
}

class _CreateCommunityWidgetState extends State<CreateCommunityWidget> {
  String name = '', description = '', regulations = '', imagePath = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                title: const Text('Create community',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.upload, color: Colors.white),
                      onPressed: () async {
                        if (name.isEmpty) {
                          Utility.showSnackBar(context, 'Please add title');
                        } else if (description.isEmpty) {
                          Utility.showSnackBar(
                              context, 'Please add the details');
                        } else if (imagePath.isEmpty) {
                          Utility.showSnackBar(
                              context, 'Please add main image');
                        } else {
                          setState(() => isLoading = true);
                          Community community = Community.forUpload(
                              name: name,
                              dateCreated: Timestamp.now(),
                              maintainerIds: [member.id!],
                              memberIds: [member.id!],
                              description: description,
                              regulations: regulations,
                              image: imagePath,
                              state: member.placemark.administrativeArea!,
                              countryISO: member.placemark.isoCountryCode!);
                          await DatabaseCommunity.uploadCommunityData(
                              community);
                          if (context.mounted) {
                            Utility.showSnackBar(context, 'Community created');
                            Navigator.of(context).pop(true);
                          }
                        }
                      })
                ]),
            resizeToAvoidBottomInset: true,
            body: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(children: [
                  Center(
                      child: Column(children: [
                    const SizedBox(height: 4),
                    TextButton.icon(
                        onPressed: () async {
                          await Utility.addMainImage((imagePath) =>
                              setState(() => this.imagePath = imagePath));
                        },
                        icon: const Icon(Icons.image),
                        label: const Text('Add main image',
                            style: TextStyle(
                                fontSize: 14, ))),
                    const SizedBox(height: 4),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: imagePath.isNotEmpty
                                ? Image.file(
                                    File(imagePath),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 250,
                                  )
                                : Container())),
                    const SizedBox(height: 20),
                    TextFormField(
                        initialValue: name,
                        onChanged: (value) => name = value,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (name.isNotEmpty ||
                                      description.isNotEmpty) {
                                    CommunityHelper.showRecommendedName(
                                        context, name, description);
                                  } else {
                                    Utility.showSnackBar(context,
                                        'Please add a name and some details first');
                                  }
                                },
                                icon: const Icon(Icons.lightbulb_outline,
                      )),
                            hintText: 'Community name',
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ))),
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        )),
                    const SizedBox(height: 20),
                    TextFormField(
                        initialValue: description,
                        onChanged: (value) => description = value,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (name.isNotEmpty ||
                                      description.isNotEmpty) {
                                    CommunityHelper.showRecommendedDescription(
                                      context,
                                      name,
                                      description,
                                    );
                                  } else {
                                    Utility.showSnackBar(context,
                                        'Please add a name and some description first');
                                  }
                                },
                                icon: const Icon(Icons.lightbulb_outline,
                                    )),
                            hintText: 'Detailed description',
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ))),
                        minLines: 10,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        )),
                    const SizedBox(height: 20),
                    TextFormField(
                        initialValue: regulations,
                        onChanged: (value) => regulations = value,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  if (name.isNotEmpty ||
                                      description.isNotEmpty) {
                                    CommunityHelper.showRecommendedRegulations(
                                        context,
                                        name,
                                        description,
                                        regulations);
                                  } else {
                                    Utility.showSnackBar(context,
                                        'Please add a name and some description first');
                                  }
                                },
                                icon: const Icon(Icons.lightbulb_outline,
                                  )),
                            hintText: 'Community guidelines',
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ))),
                        minLines: 10,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ))
                  ]))
                ])));
  }
}
