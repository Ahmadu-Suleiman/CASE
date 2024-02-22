import 'dart:io';

import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/databases/petition_database.dart';
import 'package:case_be_heard/shared/petition_helper.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreatePetitionPage extends StatefulWidget {
  final String communityId;
  const CreatePetitionPage({super.key, required this.communityId});

  @override
  State<CreatePetitionPage> createState() => _CreatePetitionPageState();
}

class _CreatePetitionPageState extends State<CreatePetitionPage> {
  final TextEditingController _controllerTarget = TextEditingController();
  String title = '', description = '', imagePath = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return isLoading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            body: Material(
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(children: [
                      Center(
                          child: Column(children: [
                        const Text('Create a new Petition',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        TextButton.icon(
                            onPressed: () async {
                              if (title.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add title');
                              } else if (description.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add the details');
                              } else if (imagePath.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add main image');
                              } else if (_controllerTarget.text.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add target');
                              } else {
                                setState(() => isLoading = true);
                                String category =
                                    await PetitionHelper.getCaseCategory(
                                        title, description);
                                int target = int.parse(_controllerTarget.text);
                                Petition petition = Petition.forUpload(
                                    title: title,
                                    description: description,
                                    image: imagePath,
                                    signatoryIds: [],
                                    target: target,
                                    category: category,
                                    memberId: member.id!,
                                    communityId: widget.communityId,
                                    dateCreated: Timestamp.now());
                                await DatabasePetition.uploadPetition(petition);
                                await DatabaseMember.addCaseOrPetitionCommunity(
                                    member, widget.communityId);
                                if (context.mounted) {
                                  PetitionHelper.showNextSteps(
                                      context, title, description);
                                }
                              }
                            },
                            icon: const Icon(Icons.upload),
                            label: const Text('Upload Petition',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ))),
                        TextButton.icon(
                            onPressed: () async {
                              await Utility.addMainImage((imagePath) =>
                                  setState(() => this.imagePath = imagePath));
                            },
                            icon: const Icon(Icons.image),
                            label: const Text('Add main image',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ))),
                        const SizedBox(height: 20),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: imagePath.isNotEmpty
                                    ? Image.file(File(imagePath),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 250)
                                    : Container())),
                        const SizedBox(height: 20),
                        TextFormField(
                            initialValue: title,
                            onChanged: (value) => title = value,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (title.isNotEmpty ||
                                          description.isNotEmpty) {
                                        PetitionHelper.showRecommendedTitle(
                                            context, title, description);
                                      } else {
                                        Utility.showSnackBar(context,
                                            'Please add a title and some details first');
                                      }
                                    },
                                    icon: const Icon(Icons.lightbulb_outline)),
                                hintText: 'Petition title',
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                        const SizedBox(height: 20),
                        TextFormField(
                            initialValue: description,
                            onChanged: (value) => description = value,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (title.isNotEmpty ||
                                          description.isNotEmpty) {
                                        PetitionHelper
                                            .showRecommendedDescription(
                                                context, title, description);
                                      } else {
                                        Utility.showSnackBar(context,
                                            'Please add a title and some details first');
                                      }
                                    },
                                    icon: const Icon(Icons.lightbulb_outline)),
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
                        TextFormField(
                            controller: _controllerTarget,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Enter the target numbr of signature',
                            ))
                      ]))
                    ]))));
  }
}
