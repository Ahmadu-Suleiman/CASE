import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:case_be_heard/custom_widgets/case_card.dart';
import 'package:provider/provider.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final _scrollController = ScrollController();
  final _caseRecords = <CaseRecord>[];
  int bottomNavIndex = 0;
  DocumentSnapshot? _lastDoc;
  bool _isLoading = false;

  Future<void> _initialize() async {
    final fetchedCaseRecord =
        await DatabaseCase.fetchCaseRecords(limit: 10, lastDoc: _lastDoc);
    setState(() => _caseRecords.addAll(fetchedCaseRecord));
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMore);
    _initialize();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMore() async {
    if (!_isLoading &&
        _scrollController.position.extentAfter < 200 &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      setState(() => _isLoading = true);
      final fetchedCaseRecord =
          await DatabaseCase.fetchCaseRecords(limit: 10, lastDoc: _lastDoc);
      setState(() => _caseRecords.addAll(fetchedCaseRecord));
    }
  }

  @override
  Widget build(BuildContext context) {
    CommunityMember? member = Provider.of<CommunityMember?>(context);
    return FutureBuilder(
        future: DatabaseCase.fetchCaseRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (snapshot.hasData) {
            _caseRecords.addAll(snapshot.data!);
            return member != null
                ? Scaffold(
                    backgroundColor: Style.secondaryColor,
                    appBar: AppBar(
                      leading: Builder(builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        );
                      }),
                      title: const Image(
                        height: 80,
                        width: 80,
                        image: AssetImage('assets/case_logo_smain.ico'),
                      ),
                      centerTitle: true,
                      actions: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // Add your logic here
                          },
                        ),
                      ],
                    ),
                    drawer: Drawer(
                      shape: Border.all(),
                      child: Container(
                        color: Colors.white,
                        child: ListView(
                          padding: const EdgeInsets.only(left: 5),
                          children: <Widget>[
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, Routes.routeMemberProfile),
                              child: UserAccountsDrawerHeader(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                accountName: Text(
                                  Utility.getFirstAndlastNam(member),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                accountEmail: Text(
                                  member.email,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                currentAccountPicture:
                                    Utility.getProfileImage(member.photoUrl),
                              ),
                            ),
                            ListTile(
                              title: const Text(
                                'Case catalog',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              leading: const Icon(Icons.folder),
                              onTap: () {
                                // Update the state of the app
                                // ...
                                // Then close the drawer
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text(
                                'Petitions',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              leading: const Icon(Icons.article),
                              onTap: () {
                                // Update the state of the app
                                // ...
                                // Then close the drawer
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text(
                                'Communities',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              leading: const Icon(Icons.people),
                              onTap: () {
                                // Update the state of the app
                                // ...
                                // Then close the drawer
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text(
                                'Achievement section',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              leading: const Icon(Icons.accessibility_sharp),
                              onTap: () {
                                // Update the state of the app
                                // ...
                                // Then close the drawer
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text(
                                'Settings',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              leading: const Icon(Icons.settings),
                              onTap: () {
                                // Update the state of the app
                                // ...
                                // Then close the drawer
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    body: RefreshIndicator(
                      onRefresh: () async {
                        // Callback for refreshing the list
                        // Clear the existing list and fetch the latest data
                        setState(() {
                          _caseRecords.clear();
                        });
                        await DatabaseCase.fetchCaseRecords()
                            .then((newRecords) {
                          setState(() => _caseRecords.addAll(newRecords));
                        });
                      },
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _caseRecords.length,
                          itemBuilder: (context, index) {
                            return CaseCard(caseRecord: _caseRecords[index]);
                          }),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, Routes.routeCreateCase),
                      shape: const CircleBorder(),
                      splashColor: Style.secondaryColor,
                      child: Icon(
                        Icons.add,
                        color: Style.primaryColor,
                      ),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: AnimatedBottomNavigationBar(
                      icons: const <IconData>[
                        Icons.home,
                        Icons.notifications,
                        Icons.message,
                        Icons.ondemand_video,
                      ],
                      activeIndex: bottomNavIndex,
                      gapLocation: GapLocation.center,
                      notchMargin: 8,
                      notchSmoothness: NotchSmoothness.sharpEdge,
                      onTap: (index) => setState(() => bottomNavIndex = index),
                    ),
                  )
                : const Loading();
          } else {
            return const Loading();
          }
        });
  }
}
