import 'package:case_be_heard/custom_widgets/case_card.dart';
import 'package:case_be_heard/custom_widgets/petition_card.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/petition_database.dart';
import 'package:flutter/material.dart';
import 'package:case_be_heard/custom_widgets/community_widget.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class CommunityMainWidget extends StatefulWidget {
  final String communityId;
  const CommunityMainWidget({super.key, required this.communityId});

  @override
  State<CommunityMainWidget> createState() => _CommunityMainWidgetState();
}

class _CommunityMainWidgetState extends State<CommunityMainWidget>
    with WidgetsBindingObserver {
  final PagingController<DocumentSnapshot?, CaseRecord>
      _pagingCaseRecordController = PagingController(firstPageKey: null);
  final PagingController<DocumentSnapshot?, Petition>
      _pagingPetitionController = PagingController(firstPageKey: null);

  @override
  void initState() {
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
        DatabaseCase.fetchCaseRecords(
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
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              title: const Image(
                height: 80,
                width: 80,
                image: AssetImage('assets/case_logo_main.ico'),
              ),
              bottom: const TabBar(tabs: [
                Tab(text: "Information"),
                Tab(text: "Cases"),
                Tab(text: "Petitions")
              ])),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      //TODO: add stuff
                      PagedSliverList<DocumentSnapshot?, CaseRecord>(
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
                      PagedSliverList<DocumentSnapshot?, Petition>(
                          pagingController: _pagingPetitionController,
                          builderDelegate: PagedChildBuilderDelegate<Petition>(
                              itemBuilder: (context, petition, index) =>
                                  PetitionCard(
                                      petition: petition, member: member),
                              noItemsFoundIndicatorBuilder: (_) =>
                                  const MesssageScreen(
                                    message: 'No cases found',
                                    icon: Icon(Icons.search_off),
                                  ),
                              noMoreItemsIndicatorBuilder: (_) =>
                                  const MesssageScreen(
                                      message: 'No more cases found',
                                      icon: Icon(Icons.search_off)))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
