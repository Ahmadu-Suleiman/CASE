import 'package:case_be_heard/custom_widgets/community_maintainer_widget.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseCommunity.getCommunityById(widget.communityId),
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        if (snapshot.hasData) {
          Community community = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
                title: const Text('Community maintainance'),
                bottom: TabBar(controller: _tabController, tabs: const [
                  Tab(text: 'Maintainers'),
                  Tab(text: 'Information')
                ])),
            body: TabBarView(
              controller: _tabController,
              children: [
                FutureBuilder<List<CommunityMember>>(
                    future: DatabaseMember.getCommunityMembersForCommunity(
                        widget
                            .communityId), // The Future your widget is based on
                    builder: (BuildContext context,
                        AsyncSnapshot<List<CommunityMember>> snapshot) {
                      if (snapshot.hasData) {
                        final members = snapshot.data!;
                        return Scaffold(
                            appBar: AppBar(
                                title: const Text('Community maintainance')),
                            body: ListView(children: [
                              const TextField(
                                  decoration: InputDecoration(
                                      hintText: 'Search members',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.search))),
                              ...members.map((member) =>
                                  CommunityMaintainerWidget(
                                      community: community,
                                      member: member,
                                      onChange: (maintainers) => setState(() =>
                                          community.maintainerIds =
                                              maintainers)))
                            ]));
                      } else {
                        return const Loading();
                      }
                    }),
                    ListView(children: [
                        TextButton.icon(
                                    onPressed: () async {
                                      await Utility.addMainImage((imagePath) =>
                                          setState(
                                              () => mainImagePath = imagePath));
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: mainImagePath.isEmpty
                                            ? Container()
                                            : mainImagePath.startsWith('http')
                                                ? Image.network(
                                                    mainImagePath,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 250,
                                                  )
                                                : Image.file(
                                                    File(mainImagePath),
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 250,
                                                  ))),
                                const SizedBox(height: 20),
                                TextFormField(
                                    controller: titleController,
                                    onChanged: (value) => title = value,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              if (title.isNotEmpty ||
                                                  details.isNotEmpty) {
                                                CaseHelper.showRecommendedTitle(
                                                    context,
                                                    title,
                                                    details,
                                                    summary);
                                              } else {
                                                Utility.showSnackBar(context,
                                                    'Please add a title and some details first');
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.lightbulb_outline)),
                                        hintText: 'Case title',
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
                                    controller: detailController,
                                    onChanged: (value) => details = value,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              if (title.isNotEmpty ||
                                                  details.isNotEmpty) {
                                                CaseHelper
                                                    .showRecommendedDescription(
                                                        context,
                                                        title,
                                                        details,
                                                        summary);
                                              } else {
                                                Utility.showSnackBar(context,
                                                    'Please add a title and some details first');
                                              }
                                            },
                                            icon: const Icon(
                                                Icons.lightbulb_outline)),
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
                                    controller: summaryController,
                                    onChanged: (value) => summary = value,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              CaseHelper.showRecommendedSummary(
                                                  context,
                                                  title,
                                                  details,
                                                  summary);
                                            },
                                            icon: const Icon(
                                                Icons.lightbulb_outline)),
                                        hintText: 'Summary',
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ))),
                                    maxLines: 6,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ))
                            
                    ],)
              ],
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
