import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/custom_widgets/case_card.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/custom_widgets/text_icon.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/location.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProfileOthers extends StatefulWidget {
  final String memberId;
  const ProfileOthers({super.key, required this.memberId});

  @override
  State<ProfileOthers> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileOthers> with WidgetsBindingObserver {
  final PagingController<DocumentSnapshot?, CaseRecord> _pagingController =
      PagingController(firstPageKey: null);

  String progress = CaseValues.investigationPending;
  CommunityMember member = CommunityMember.empty();
  String address = '';
  bool loading = true;

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
    setup();
    super.initState();
  }

  void setup() async {
    member = await DatabaseMember.getCommunityMember(widget.memberId);
    address = await LocationService.getLocationAddressString(member.location);
    setState(() => loading = false);
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
    if (loading) {
      return const Loading();
    } else {
      return Scaffold(
          appBar: AppBar(
              backgroundColor: Style.primaryColor,
              title: const Image(
                  height: 80,
                  width: 80,
                  image: AssetImage('assets/case_logo_main.ico')),
              centerTitle: true),
          body: RefreshIndicator(
              onRefresh: () async {
                _pagingController.refresh();
              },
              child: CustomScrollView(slivers: [
                SliverToBoxAdapter(
                    child: Column(children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(8),
                      color: Style.primaryColor,
                      child: CachedAvatar(
                          url: member.photoUrl,
                          size: 60,
                          onPressed: () => context.push(
                              '${Routes.casePhoto}/${Uri.encodeComponent(member.photoUrl)}'))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      const SizedBox(height: 12.0),
                      Text(
                        Utility.getFirstAndlastName(member),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 8.0),
                      IconText(
                          icon: Icons.email,
                          iconSize: 18,
                          text: member.email,
                          fontSize: 16),
                      const SizedBox(height: 8.0),
                      IconText(
                          icon: Icons.phone,
                          iconSize: 18,
                          text: member.phoneNumber,
                          fontSize: 16),
                      const SizedBox(height: 8.0),
                      IconText(
                          icon: Icons.work,
                          iconSize: 18,
                          text: member.occupation,
                          fontSize: 16),
                      const SizedBox(height: 8.0),
                      IconText(
                          icon: Icons.location_on,
                          iconSize: 18,
                          text: member.address,
                          fontSize: 16),
                      const SizedBox(height: 8.0),
                      Text(member.bio,
                          maxLines: 4,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14)),
                    ]),
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                          //fill horizontally
                          showSelectedIcon: false,
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Style.primaryColor;
                                }
                                return Colors.white;
                              }),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero))),
                          segments: const <ButtonSegment<String>>[
                            ButtonSegment<String>(
                                value: CaseValues.investigationPending,
                                label: Text(CaseValues.pending)),
                            ButtonSegment<String>(
                                value: CaseValues.investigationOngoing,
                                label: Text(CaseValues.ongoing)),
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
                                icon: Icon(Icons.search_off))))
              ])));
    }
  }
}
