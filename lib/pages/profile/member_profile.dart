import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/custom_widgets/case_card_edit.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/text_icon.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final PagingController<DocumentSnapshot?, CaseRecord> _pagingController =
      PagingController(firstPageKey: null);
  int bottomNavIndex = 0;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      DatabaseCase.fetchCaseRecords(
          pagingController: _pagingController, limit: 10, pageKey: pageKey);
    });
    super.initState();
  }

  String address = '';
  @override
  Widget build(BuildContext context) {
    CommunityMember member = Provider.of<CommunityMember>(context);
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
                        Navigator.pushNamed(context, '/edit_member_profile');
                      },
                      icon: const Icon(Icons.edit),
                    )
                  ],
                ),
                body: Column(
                  children: <Widget>[
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
                          IconText(icon: Icons.phone, text: member.phoneNumber),
                          IconText(icon: Icons.work, text: member.occupation),
                          IconText(icon: Icons.location_on, text: address),
                          Text(
                            member.bio,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1, // Adjust this value to allocate space for TabBar
                      child: TabBar(
                        tabs: [
                          Tab(text: 'Pending Cases'),
                          Tab(text: 'Solved Cases'),
                          Tab(text: 'Petitions'),
                        ],
                      ),
                    ),
                    Expanded(
                      flex:
                          6, // Adjust this value to allocate space for TabBarView
                      child: TabBarView(
                        children: <Widget>[
                          RefreshIndicator(
                            onRefresh: () async {
                              _pagingController.refresh();
                            },
                            child: PagedListView<DocumentSnapshot?, CaseRecord>(
                              pagingController: _pagingController,
                              builderDelegate:
                                  PagedChildBuilderDelegate<CaseRecord>(
                                itemBuilder: (context, item, index) =>
                                    CaseCardEdit(caseRecord: item),
                              ),
                            ),
                          ),
                          Center(child: Text('Content   2')),
                          Center(child: Text('Content   3')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
