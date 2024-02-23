import 'dart:io';

import 'package:case_be_heard/custom_widgets/community_maintainer_widget.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/shared/community_helper.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';

class CommunitySettingsPage extends StatefulWidget {
  final String communityId;
  const CommunitySettingsPage({super.key, required this.communityId});

  @override
  State<CommunitySettingsPage> createState() => _CommunitySettingsPageState();
}

class _CommunitySettingsPageState extends State<CommunitySettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String imagePath = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : FutureBuilder(
            future: DatabaseCommunity.getCommunityById(widget.communityId),
            builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
              if (snapshot.hasData) {
                Community community = snapshot.data!;
                imagePath = community.image;
                TextEditingController name = TextEditingController();
                TextEditingController description = TextEditingController();
                TextEditingController regulations = TextEditingController();
                name.text = community.name;
                description.text = community.description;
                regulations.text = community.regulations;

                return Scaffold(
                    appBar: AppBar(
                        title: const Text('Community maintainance'),
                        bottom: TabBar(controller: _tabController, tabs: const [
                          Tab(text: 'Maintainers'),
                          Tab(text: 'Information')
                        ])),
                    body: TabBarView(controller: _tabController, children: [
                      FutureBuilder<List<CommunityMember>>(
                          future: DatabaseMember
                              .getCommunityMembersForCommunity(widget
                                  .communityId), // The Future your widget is based on
                          builder: (BuildContext context,
                              AsyncSnapshot<List<CommunityMember>> snapshot) {
                            if (snapshot.hasData) {
                              final members = snapshot.data!;
                              return ListView(children: [
                                const TextField(
                                    decoration: InputDecoration(
                                        hintText: 'Search members',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.search))),
                                ...members.map((member) =>
                                    CommunityMaintainerWidget(
                                        community: community,
                                        member: member,
                                        onChange: (maintainers) => setState(
                                            () => community.maintainerIds =
                                                maintainers)))
                              ]);
                            } else {
                              return const Loading();
                            }
                          }),
                      ListView(children: [
                        TextButton.icon(
                            onPressed: () async {
                              if (name.text.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add title');
                              } else if (description.text.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add the details');
                              } else if (imagePath.isEmpty) {
                                Utility.showSnackBar(
                                    context, 'Please add main image');
                              } else {
                                setState(() => isLoading = true);
                                Community communityForUpdate =
                                    Community.forUpdate(
                                        id: community.id,
                                        name: name.text,
                                        maintainerIds: community.maintainerIds,
                                        memberIds: community.memberIds,
                                        description: description.text,
                                        regulations: regulations.text,
                                        image: imagePath,
                                        state: community.state,
                                        countryISO: community.countryISO);
                                await DatabaseCommunity.updateCommunityData(
                                    communityForUpdate);
                                if (context.mounted) {
                                  Utility.showSnackBar(
                                      context, 'Community updated');
                                  Navigator.of(context).pop(true);
                                }
                              }
                            },
                            icon: const Icon(Icons.upload),
                            label: const Text('Update Community',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ))),
                        TextButton.icon(
                            onPressed: () async {
                              await Utility.addMainImage((imagePath) =>
                                  setState(() => imagePath = imagePath));
                            },
                            icon: const Icon(Icons.image),
                            label: const Text('Add main image',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.blue))),
                        const SizedBox(height: 20),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: imagePath.isEmpty
                                    ? Container()
                                    : imagePath.startsWith('http')
                                        ? Image.network(imagePath,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 250)
                                        : Image.file(File(imagePath),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 250))),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: name,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (name.text.isNotEmpty ||
                                          description.text.isNotEmpty) {
                                        CommunityHelper.showRecommendedName(
                                            context,
                                            name.text,
                                            description.text);
                                      } else {
                                        Utility.showSnackBar(context,
                                            'Please add a name and some details first');
                                      }
                                    },
                                    icon: const Icon(Icons.lightbulb_outline)),
                                hintText: 'Community name',
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ))),
                            maxLines: 1,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black)),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: description,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (name.text.isNotEmpty ||
                                          description.text.isNotEmpty) {
                                        CommunityHelper
                                            .showRecommendedDescription(context,
                                                name.text, description.text);
                                      } else {
                                        Utility.showSnackBar(context,
                                            'Please add a name and some description first');
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
                                fontSize: 18, color: Colors.black)),
                        const SizedBox(height: 20),
                        TextFormField(
                            controller: regulations,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      if (name.text.isNotEmpty ||
                                          description.text.isNotEmpty) {
                                        CommunityHelper
                                            .showRecommendedRegulations(
                                                context,
                                                name.text,
                                                description.text,
                                                regulations.text);
                                      } else {
                                        Utility.showSnackBar(context,
                                            'Please add a name and some description first');
                                      }
                                    },
                                    icon: const Icon(Icons.lightbulb_outline)),
                                hintText: 'Community guidelines',
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                            minLines: 10,
                            maxLines: null,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black))
                      ])
                    ]));
              } else {
                return const Loading();
              }
            });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
