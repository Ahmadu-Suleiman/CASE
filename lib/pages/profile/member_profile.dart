import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/custom_widgets/case_card_edit.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/custom_widgets/text_icon.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  final String memberId;
  const Profile({super.key, required this.memberId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with WidgetsBindingObserver {
  final PagingController<DocumentSnapshot?, CaseRecord> _pagingController =
      PagingController(firstPageKey: null);

  String progress = CaseValues.investigationPending;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      WidgetsBinding.instance.addObserver(this);
      DatabaseCase.fetchCaseRecords(
          pagingController: _pagingController,
          limit: 10,
          pageKey: pageKey,
          progress: progress,
          memberId: widget.memberId);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // The app has come back to the foreground, refresh the PagedListView
      _pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return Scaffold(
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
                  context.push(Routes.editMemberProfile);
                },
                icon: const Icon(Icons.edit),
              )
            ]),
        body: RefreshIndicator(
            onRefresh: () async {
              _pagingController.refresh();
            },
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                  child: Column(children: <Widget>[
                CachedAvatar(
                    url: member.photoUrl,
                    size: 60,
                    onPressed: () => context.push(
                        '${Routes.casePhoto}/${Uri.encodeComponent(member.photoUrl)}')),
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
                IconText(icon: Icons.phone, text: member.phoneNumber),
                IconText(icon: Icons.work, text: member.occupation),
                IconText(icon: Icons.location_on, text: member.address),
                Text(member.bio, maxLines: 4),
                SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                        //fill horizontally
                        showSelectedIcon: false,
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.zero, // This removes the curve
                        ))),
                        segments: const <ButtonSegment<String>>[
                          ButtonSegment<String>(
                            value: CaseValues.investigationPending,
                            label: Text(CaseValues.pending),
                          ),
                          ButtonSegment<String>(
                            value: CaseValues.investigationOngoing,
                            label: Text(CaseValues.ongoing),
                          ),
                          ButtonSegment<String>(
                              value: CaseValues.caseSolved,
                              label: Text(CaseValues.solved))
                        ],
                        selected: <String>{progress},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            progress = newSelection.first;
                            _pagingController.refresh();
                          });
                        }))
              ])),
              PagedSliverList<DocumentSnapshot?, CaseRecord>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<CaseRecord>(
                      itemBuilder: (context, item, index) => CaseCardEdit(
                          caseRecord: item,
                          update: () {
                            _pagingController.refresh();
                          }),
                      noItemsFoundIndicatorBuilder: (_) => const MesssageScreen(
                            message: 'No cases found',
                            icon: Icon(Icons.search_off),
                          ),
                      noMoreItemsIndicatorBuilder: (_) => const MesssageScreen(
                          message: 'No more cases found',
                          icon: Icon(Icons.search_off))))
            ])));
  }
}
