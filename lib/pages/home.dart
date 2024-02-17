import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
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
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return Scaffold(
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
            padding: const EdgeInsets.only(left: 6),
            children: <Widget>[
              GestureDetector(
                onTap: () => context.push(Routes.memberProfile),
                child: UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  accountName: Text(
                    Utility.getFirstAndlastName(member),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    member.email,
                    style: const TextStyle(color: Colors.black),
                  ),
                  currentAccountPicture:
                      CachedAvatar(url: member.photoUrl, size: 60),
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
                  'Bookmarks',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.bookmark),
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
          _pagingController.refresh();
        },
        child: PagedListView<DocumentSnapshot?, CaseRecord>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<CaseRecord>(
            itemBuilder: (context, caseRecord, index) => VisibilityDetector(
                key: Key(caseRecord.uid),
                onVisibilityChanged: (VisibilityInfo info) {
                  var visiblePercentage = info.visibleFraction * 100;
                  if (visiblePercentage >= 50) {
                    DatabaseCase.addCaseView(member.uid!, caseRecord);
                  }
                },
                child: CaseCard(caseRecord: caseRecord)),
            noItemsFoundIndicatorBuilder: (_) => const MesssageScreen(
              message: 'No cases found',
              icon: Icon(Icons.search_off),
            ),
            noMoreItemsIndicatorBuilder: (_) => const MesssageScreen(
              message: 'No more cases found',
              icon: Icon(Icons.search_off),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Routes.createCase),
        shape: const CircleBorder(),
        splashColor: Style.secondaryColor,
        child: Icon(
          Icons.add,
          color: Style.primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
