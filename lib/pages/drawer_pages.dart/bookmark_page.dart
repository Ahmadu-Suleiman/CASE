import 'package:case_be_heard/custom_widgets/case_card.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/custom_widgets/petition_card.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/petition_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookmarkWidget extends StatefulWidget {
  const BookmarkWidget({super.key});

  @override
  State<BookmarkWidget> createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return Scaffold(
        appBar: AppBar(
            title: const Text('Bookmarks'),
            centerTitle: true,
            bottom: TabBar(
                controller: _tabController,
                tabs: const [Tab(text: 'Cases'), Tab(text: 'Petitions')])),
        body: TabBarView(controller: _tabController, children: [
          FutureBuilder<List<CaseRecord>>(
              future: DatabaseCase.getCaseRecordsByIds(member.bookmarkCaseIds),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CaseRecord>> snapshot) {
                if (snapshot.hasData) {
                  final caseRecords = snapshot.data!;
                  if (caseRecords.isNotEmpty) {
                    return ListView.builder(
                        itemCount: caseRecords.length,
                        itemBuilder: (context, index) {
                          return CaseCard(caseRecord: caseRecords[index]);
                        });
                  } else {
                    return const MesssageScreen(
                        message: 'No cases bookmarked',
                        icon: Icon(Icons.search));
                  }
                }
                return const Loading();
              }),
          FutureBuilder<List<Petition>>(
              future: DatabasePetition.getPetitionsByIds(
                  member.bookmarkPetitionIds),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Petition>> snapshot) {
                if (snapshot.hasData) {
                  final petitions = snapshot.data!;
                  if (petitions.isNotEmpty) {
                    return ListView.builder(
                        itemCount: petitions.length,
                        itemBuilder: (context, index) {
                          return PetitionCard(
                              petition: petitions[index], member: member);
                        });
                  } else {
                    return const MesssageScreen(
                        message: 'No petitions bookmarked',
                        icon: Icon(Icons.search));
                  }
                }
                return const Loading();
              })
        ]));
  }
}
