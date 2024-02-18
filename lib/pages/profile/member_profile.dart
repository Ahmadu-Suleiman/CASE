import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/custom_widgets/case_card_edit.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/custom_widgets/text_icon.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/location.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with WidgetsBindingObserver {
  final PagingController<DocumentSnapshot?, CaseRecord>
      _pagingControllerPending = PagingController(firstPageKey: null);
  final PagingController<DocumentSnapshot?, CaseRecord>
      _pagingControllerOngoing = PagingController(firstPageKey: null);
  final PagingController<DocumentSnapshot?, CaseRecord>
      _pagingControllerSolved = PagingController(firstPageKey: null);
  int bottomNavIndex = 0;
  String address = '';

  @override
  void initState() {
    _pagingControllerPending.addPageRequestListener((pageKey) {
      WidgetsBinding.instance.addObserver(this);
      DatabaseCase.fetchCaseRecords(
          pagingController: _pagingControllerPending,
          limit: 10,
          pageKey: pageKey,
          progress: CaseValues.investigationPending);
    });

    _pagingControllerOngoing.addPageRequestListener((pageKey) {
      WidgetsBinding.instance.addObserver(this);
      DatabaseCase.fetchCaseRecords(
          pagingController: _pagingControllerOngoing,
          limit: 10,
          pageKey: pageKey,
          progress: CaseValues.investigationOngoing);
    });

    _pagingControllerSolved.addPageRequestListener((pageKey) {
      WidgetsBinding.instance.addObserver(this);
      DatabaseCase.fetchCaseRecords(
          pagingController: _pagingControllerSolved,
          limit: 10,
          pageKey: pageKey,
          progress: CaseValues.caseSolved);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingControllerPending.dispose();
    _pagingControllerOngoing.dispose();
    _pagingControllerSolved.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // The app has come back to the foreground, refresh the PagedListView
      _pagingControllerPending.refresh();
      _pagingControllerOngoing.refresh();
      _pagingControllerSolved.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return FutureBuilder(
        future: LocationService.getLocationAddress(member.location),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            address = snapshot.data!;
            return DefaultTabController(
                length: 3, // Number of tabs
                child: Scaffold(
                    appBar: AppBar(
                        title: const Image(
                          height: 80,
                          width: 80,
                          image: AssetImage('assets/case_logo_main.ico'),
                        ),
                        centerTitle: true,
                        actions: [
                          IconButton.filled(
                            onPressed: () async {
                              context.go(Routes.editMemberProfile);
                            },
                            icon: const Icon(Icons.edit),
                          )
                        ]),
                    body: Column(children: <Widget>[
                      Expanded(
                          flex:
                              4, // Adjust this value to allocate space for Text widgets
                          child: ListView(
                              padding: const EdgeInsets.all(8),
                              children: <Widget>[
                                CachedAvatar(url: member.photoUrl, size: 60),
                                Text(
                                  '${member.firstName} ${member.lastName}',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                IconText(icon: Icons.email, text: member.email),
                                IconText(
                                    icon: Icons.phone,
                                    text: member.phoneNumber),
                                IconText(
                                    icon: Icons.work, text: member.occupation),
                                IconText(
                                    icon: Icons.location_on, text: address),
                                Text(
                                  member.bio,
                                  maxLines: 4,
                                )
                              ])),
                      const Expanded(
                          flex:
                              1, // Adjust this value to allocate space for TabBar
                          child: TabBar(tabs: [
                            Tab(text: 'Pending'),
                            Tab(text: 'Ongoing'),
                            Tab(text: 'Solved Cases')
                          ])),
                      Expanded(
                          flex:
                              6, // Adjust this value to allocate space for TabBarView
                          child: TabBarView(children: <Widget>[
                            RefreshIndicator(
                                onRefresh: () async {
                                  _pagingControllerPending.refresh();
                                },
                                child: PagedListView<DocumentSnapshot?,
                                        CaseRecord>(
                                    //for investigation pending
                                    pagingController: _pagingControllerPending,
                                    builderDelegate:
                                        PagedChildBuilderDelegate<CaseRecord>(
                                            itemBuilder:
                                                (context, item, index) =>
                                                    CaseCardEdit(
                                                        caseRecord: item,
                                                        update: () {
                                                          _pagingControllerPending
                                                              .refresh();
                                                        }),
                                            noItemsFoundIndicatorBuilder: (_) =>
                                                const MesssageScreen(
                                                  message: 'No cases found',
                                                  icon: Icon(Icons.search_off),
                                                ),
                                            noMoreItemsIndicatorBuilder: (_) =>
                                                const MesssageScreen(
                                                  message:
                                                      'No more cases found',
                                                  icon: Icon(Icons.search_off),
                                                )))),
                            RefreshIndicator(
                                onRefresh: () async {
                                  _pagingControllerOngoing.refresh();
                                },
                                child: PagedListView<DocumentSnapshot?,
                                        CaseRecord>(
                                    // for investigation ongoing
                                    pagingController: _pagingControllerOngoing,
                                    builderDelegate:
                                        PagedChildBuilderDelegate<CaseRecord>(
                                            itemBuilder:
                                                (context, item, index) =>
                                                    CaseCardEdit(
                                                        caseRecord: item,
                                                        update: () {
                                                          _pagingControllerOngoing
                                                              .refresh();
                                                        }),
                                            noItemsFoundIndicatorBuilder: (_) =>
                                                const MesssageScreen(
                                                  message: 'No cases found',
                                                  icon: Icon(Icons.search_off),
                                                ),
                                            noMoreItemsIndicatorBuilder: (_) =>
                                                const MesssageScreen(
                                                  message:
                                                      'No more cases found',
                                                  icon: Icon(Icons.search_off),
                                                )))),
                            RefreshIndicator(
                                onRefresh: () async {
                                  _pagingControllerSolved.refresh();
                                },
                                child: PagedListView<DocumentSnapshot?,
                                        CaseRecord>(
                                    // for case solved
                                    pagingController: _pagingControllerSolved,
                                    builderDelegate:
                                        PagedChildBuilderDelegate<CaseRecord>(
                                            itemBuilder:
                                                (context, item, index) =>
                                                    CaseCardEdit(
                                                        caseRecord: item,
                                                        update: () {
                                                          _pagingControllerSolved
                                                              .refresh();
                                                        }),
                                            noItemsFoundIndicatorBuilder: (_) =>
                                                const MesssageScreen(
                                                  message: 'No cases found',
                                                  icon: Icon(Icons.search_off),
                                                ),
                                            noMoreItemsIndicatorBuilder: (_) =>
                                                const MesssageScreen(
                                                  message:
                                                      'No more cases found',
                                                  icon: Icon(Icons.search_off),
                                                ))))
                          ]))
                    ])));
          } else {
            return const Loading();
          }
        });
  }
}
