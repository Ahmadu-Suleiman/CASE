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
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('yourCollection');
  final PagingController<DocumentSnapshot, CaseRecord> _pagingController =
      PagingController(firstPageKey: null);
  final ScrollController _scrollController = ScrollController();
  int bottomNavIndex = 0;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _pagingController.addPageRequestListener((pageKey) {
      DatabaseCase.fetchCaseRecords(
          pagingController: _pagingController, limit: 10, pageKey: pageKey);
    });
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _pagingController.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    CommunityMember? member = Provider.of<CommunityMember?>(context);
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
                image: AssetImage('assets/case_logo_main.ico'),
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
                              color: Colors.black, fontWeight: FontWeight.bold),
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
              onRefresh: () async {'https://www.phind.com/agent?cache=clsj9ssrc0017ju089wfcfeyi'
                // Callback for refreshing the list
                // Clear the existing list and fetch the latest data
                setState(() => _caseRecords.clear());
                await DatabaseCase.fetchCaseRecords().then((newRecords) {
                  setState(() => _caseRecords.addAll(newRecords));
                });
              },
              child: PagedListView<DocumentSnapshot, CaseRecord>(
                pagingController: _pagingController,
                scrollController: _scrollController,
                builderDelegate: PagedChildBuilderDelegate<CaseRecord>(
                  itemBuilder: (context, item, index) =>
                      CaseCard(caseRecord: caseRecords[index]),
                ),
              ),
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
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
