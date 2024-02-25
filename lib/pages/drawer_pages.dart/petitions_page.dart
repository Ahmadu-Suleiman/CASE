import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/custom_widgets/petition_card.dart';
import 'package:case_be_heard/custom_widgets/petition_card_edit.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/services/databases/petition_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class PetitionsPageWidget extends StatefulWidget {
  const PetitionsPageWidget({super.key});

  @override
  State<PetitionsPageWidget> createState() => _PetitionsPageWidgetState();
}

class _PetitionsPageWidgetState extends State<PetitionsPageWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final PagingController<DocumentSnapshot?, Petition> _pagingController =
      PagingController(firstPageKey: null);
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
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
    _pagingController.addPageRequestListener((pageKey) {
      WidgetsBinding.instance.addObserver(this);
      DatabasePetition.fetchPetitions(
          pagingController: _pagingController,
          limit: 10,
          pageKey: pageKey,
          communityIds: member.communityIds);
    });
    return Scaffold(
        appBar: AppBar(
            title: const Text('Petitions',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            centerTitle: true,
            bottom: TabBar(
                controller: _tabController,
                tabs: const [Tab(text: 'Created'), Tab(text: 'Others')])),
        body: TabBarView(controller: _tabController, children: [
          FutureBuilder<List<Petition>>(
              future: DatabasePetition.getPetitions(member.id!),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Petition>> snapshot) {
                if (snapshot.hasData) {
                  final petitions = snapshot.data!;
                  if (petitions.isNotEmpty) {
                    return ListView.builder(
                        itemCount: petitions.length,
                        itemBuilder: (context, index) {
                          return PetitionCardEdit(
                              petition: petitions[index],
                              member: member,
                              onDelete: () async {
                                DatabasePetition.deletePetition(
                                        petitions[index])
                                    .then((_) => setState(() {}));
                              });
                        });
                  } else {
                    return const MesssageScreen(
                        message: 'No petitions created',
                        icon: Icon(Icons.search));
                  }
                }
                return const Loading();
              }),
          RefreshIndicator(
              onRefresh: () async {
                _pagingController.refresh();
              },
              child: PagedListView<DocumentSnapshot?, Petition>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Petition>(
                      itemBuilder: (context, petition, index) =>
                          PetitionCard(petition: petition, member: member),
                      noItemsFoundIndicatorBuilder: (_) => const MesssageScreen(
                            message: 'No cases found',
                            icon: Icon(Icons.search_off),
                          ),
                      noMoreItemsIndicatorBuilder: (_) => const MesssageScreen(
                          message: 'No more cases found',
                          icon: Icon(Icons.search_off)))))
        ]));
  }
}
