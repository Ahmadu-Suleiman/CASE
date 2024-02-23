import 'package:case_be_heard/custom_widgets/case_card.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/petition_card.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/databases/petition_database.dart';
import 'package:case_be_heard/shared/community_helper.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:flutter/material.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class CommunityMainPage extends StatefulWidget {
  final String communityId;
  const CommunityMainPage({super.key, required this.communityId});

  @override
  State<CommunityMainPage> createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late TabController _tabController;

  final PagingController<DocumentSnapshot?, CaseRecord>
      _pagingCaseRecordController = PagingController(firstPageKey: null);
  final PagingController<DocumentSnapshot?, Petition>
      _pagingPetitionController = PagingController(firstPageKey: null);

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    DatabaseCommunity.getCommunityById(widget.communityId).then((community) {
      _pagingCaseRecordController.addPageRequestListener((pageKey) {
        WidgetsBinding.instance.addObserver(this);
        DatabaseCase.fetchCaseRecords(
            pagingController: _pagingCaseRecordController,
            limit: 10,
            pageKey: pageKey,
            communityId: community.id);
      });
      _pagingPetitionController.addPageRequestListener((pageKey) {
        WidgetsBinding.instance.addObserver(this);
        DatabasePetition.fetchPetitions(
            pagingController: _pagingPetitionController,
            limit: 10,
            pageKey: pageKey,
            communityId: community.id);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pagingCaseRecordController.dispose();
    _pagingPetitionController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // The app has come back to the foreground, refresh the PagedListView
      _pagingCaseRecordController.refresh();
      _pagingCaseRecordController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return StreamBuilder(
        stream: DatabaseCommunity.getCommunity(widget.communityId),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            Community community = snapshot.data!;
            bool isCommunityMaintainer = community.maintainerIds.contains(member.id);
            return DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Scaffold(
                    appBar: AppBar(
                        title: Text(community.name),
                        actions: <Widget>[isCommunityMaintainer?IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () async {
                                if (CommunityHelper.isCommunityMember(
                                    member, community)) {
                                  await DatabaseMember.removeCommunity(
                                          member, community)
                                      .then((communityIds) => setState(() =>
                                          member.communityIds = communityIds));
                                } else {
                                  await DatabaseMember.addCommunity(
                                          member, community)
                                      .then((communityIds) => setState(() =>
                                          member.communityIds = communityIds));
                                }
                              }):
                          IconButton(
                              icon: const Icon(Icons.group_add),
                              color: CommunityHelper.isCommunityMember(
                                      member, community)
                                  ? Style.primaryColor
                                  : Colors.black,
                              onPressed: () async {
                                if (CommunityHelper.isCommunityMember(
                                    member, community)) {
                                  await DatabaseMember.removeCommunity(
                                          member, community)
                                      .then((communityIds) => setState(() =>
                                          member.communityIds = communityIds));
                                } else {
                                  await DatabaseMember.addCommunity(
                                          member, community)
                                      .then((communityIds) => setState(() =>
                                          member.communityIds = communityIds));
                                }
                              })
                        ],
                        bottom: TabBar(controller: _tabController, tabs: const [
                          Tab(text: "Cases"),
                          Tab(text: "Petitions"),
                          Tab(text: "Information")
                        ])),
                    body: TabBarView(controller: _tabController, children: [
                      PagedListView<DocumentSnapshot?, CaseRecord>(
                          pagingController: _pagingCaseRecordController,
                          builderDelegate:
                              PagedChildBuilderDelegate<CaseRecord>(
                                  itemBuilder: (context, item, index) =>
                                      CaseCard(caseRecord: item),
                                  noItemsFoundIndicatorBuilder: (_) =>
                                      const MesssageScreen(
                                        message: 'No cases found',
                                        icon: Icon(Icons.search_off),
                                      ),
                                  noMoreItemsIndicatorBuilder: (_) =>
                                      const MesssageScreen(
                                          message: 'No more cases found',
                                          icon: Icon(Icons.search_off)))),
                      PagedListView<DocumentSnapshot?, Petition>(
                          pagingController: _pagingPetitionController,
                          builderDelegate: PagedChildBuilderDelegate<Petition>(
                              itemBuilder: (context, petition, index) =>
                                  PetitionCard(
                                      petition: petition, member: member),
                              noItemsFoundIndicatorBuilder: (_) =>
                                  const MesssageScreen(
                                    message: 'No petitions found',
                                    icon: Icon(Icons.search_off),
                                  ),
                              noMoreItemsIndicatorBuilder: (_) =>
                                  const MesssageScreen(
                                      message: 'No more petitions found',
                                      icon: Icon(Icons.search_off)))),
                      ListView(padding: const EdgeInsets.all(8), children: [
                        const Text('Community description',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold)),
                        SelectableText(community.description),
                        const Text('Community guidelines',
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold)),
                        SelectableText(community.regulations)
                      ])
                    ])));
          }
          return const Loading();
        }));
  }
}
