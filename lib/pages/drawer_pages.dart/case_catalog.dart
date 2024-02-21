import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:case_be_heard/custom_widgets/case_card_edit.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/location.dart';
import 'package:case_be_heard/shared/case_values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class CaseCatalog extends StatefulWidget {
  const CaseCatalog({super.key});

  @override
  State<CaseCatalog> createState() => _CaseCatalogState();
}

class _CaseCatalogState extends State<CaseCatalog> with WidgetsBindingObserver {
  final PagingController<DocumentSnapshot?, CaseRecord> _pagingController =
      PagingController(firstPageKey: null);

  String progress = CaseValues.investigationPending;
  String address = '';

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      WidgetsBinding.instance.addObserver(this);
      DatabaseCase.fetchCaseRecords(
          pagingController: _pagingController,
          limit: 10,
          pageKey: pageKey,
          progress: progress);
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
    return FutureBuilder(
        future: LocationService.getLocationAddressString(member.location),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            address = snapshot.data!;
            return Scaffold(
                appBar: AppBar(
                  title: const Image(
                    height: 80,
                    width: 80,
                    image: AssetImage('assets/case_logo_main.ico'),
                  ),
                  centerTitle: true,
                ),
                body: RefreshIndicator(
                    onRefresh: () async {
                      _pagingController.refresh();
                    },
                    child: CustomScrollView(slivers: [
                      SliverToBoxAdapter(
                          child: Column(children: <Widget>[
                        SizedBox(
                            width: double.infinity,
                            child: SegmentedButton<String>(
                                //fill horizontally
                                showSelectedIcon: false,
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        const RoundedRectangleBorder(
                                  borderRadius: BorderRadius
                                      .zero, // This removes the curve
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
                          builderDelegate:
                              PagedChildBuilderDelegate<CaseRecord>(
                                  itemBuilder: (context, item, index) =>
                                      CaseCardEdit(
                                          caseRecord: item,
                                          update: () {
                                            _pagingController.refresh();
                                          }),
                                  noItemsFoundIndicatorBuilder: (_) =>
                                      const MesssageScreen(
                                          message: 'No cases found',
                                          icon: Icon(Icons.search_off)),
                                  noMoreItemsIndicatorBuilder: (_) =>
                                      const MesssageScreen(
                                          message: 'No more cases found',
                                          icon: Icon(Icons.search_off))))
                    ])));
          } else {
            return const Loading();
          }
        });
  }
}
