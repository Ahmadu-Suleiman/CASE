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
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
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
                  })
            ]),
        drawer: Drawer(
            shape: Border.all(),
            child: Container(
                color: Colors.white,
                child: ListView(
                    padding: const EdgeInsets.only(left: 6),
                    children: <Widget>[
                      UserAccountsDrawerHeader(
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
                        currentAccountPicture: CachedAvatar(
                            url: member.photoUrl,
                            size: 80,
                            onPressed: () => context
                                .push('${Routes.memberProfile}/${member.id}')),
                      ),
                      ListTile(
                        title: const Text(
                          'Case catalog',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        leading: const Icon(Icons.folder),
                        onTap: () {
                          context.push(Routes.caseCatalog);
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
                            context.push(Routes.petitionPage);
                            Navigator.pop(context);
                          }),
                      ListTile(
                          title: const Text(
                            'Bookmarks',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: const Icon(Icons.bookmark),
                          onTap: () {
                            context.push(Routes.bookmarks);
                            Navigator.pop(context);
                          }),
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
                          }),
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
                          }),
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
                          })
                    ]))),
        body: RefreshIndicator(
            onRefresh: () async {
              _pagingController.refresh();
            },
            child: PagedListView<DocumentSnapshot?, CaseRecord>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<CaseRecord>(
                    itemBuilder: (context, caseRecord, index) =>
                        VisibilityDetector(
                            key: Key(caseRecord.id),
                            onVisibilityChanged: (VisibilityInfo info) {
                              var visiblePercentage =
                                  info.visibleFraction * 100;
                              if (visiblePercentage >= 50) {
                                DatabaseCase.addCaseView(
                                    member.id!, caseRecord);
                              }
                            },
                            child: CaseCard(caseRecord: caseRecord)),
                    noItemsFoundIndicatorBuilder: (_) => const MesssageScreen(
                          message: 'No cases found',
                          icon: Icon(Icons.search_off),
                        ),
                    noMoreItemsIndicatorBuilder: (_) => const MesssageScreen(
                        message: 'No more cases found',
                        icon: Icon(Icons.search_off))))),
        floatingActionButton: ExpandableFab(
            openButtonBuilder: RotateFloatingActionButtonBuilder(
              child: const Icon(Icons.add),
              fabSize: ExpandableFabSize.regular,
              foregroundColor: Style.primaryColor,
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
            ),
            closeButtonBuilder: DefaultFloatingActionButtonBuilder(
              child: const Icon(Icons.close),
              fabSize: ExpandableFabSize.small,
              foregroundColor: Style.primaryColor,
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
            ),
            children: [
              GestureDetector(
                onLongPress: () =>
                    Utility.showSnackBar(context, 'create a petition'),
                child: SizedBox(
                    width: 60,
                    height: 60,
                    child: FloatingActionButton.large(
                        heroTag: null,
                        child: const Icon(Icons.article),
                        onPressed: () => context.push(Routes.createPetition))),
              ),
              GestureDetector(
                onLongPress: () =>
                    Utility.showSnackBar(context, 'create a case'),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: FloatingActionButton.large(
                      heroTag: null,
                      child: const Icon(Icons.insert_drive_file),
                      onPressed: () => context.push(Routes.createCase)),
                ),
              )
            ]),
        floatingActionButtonLocation: ExpandableFab.location,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: const <IconData>[
            Icons.home,
            Icons.notifications,
            Icons.message,
            Icons.ondemand_video,
          ],
          activeIndex: bottomNavIndex,
          gapLocation: GapLocation.none,
          notchMargin: 8,
          elevation: 0.0,
          notchSmoothness: NotchSmoothness.sharpEdge,
          onTap: (index) => setState(() => bottomNavIndex = index),
        ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
