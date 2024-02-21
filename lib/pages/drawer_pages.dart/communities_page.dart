import 'package:case_be_heard/custom_widgets/community_widget.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class CommunitiesPageWidget extends StatefulWidget {
  final String state;
  final String countryISO;
  const CommunitiesPageWidget(
      {super.key, required this.state, required this.countryISO});

  @override
  State<CommunitiesPageWidget> createState() => _CommunitiesWidgetState();
}

class _CommunitiesWidgetState extends State<CommunitiesPageWidget>
    with WidgetsBindingObserver {
  final PagingController<DocumentSnapshot?, Community> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      WidgetsBinding.instance.addObserver(this);
      DatabaseCommunity.fetchCommunities(
          pagingController: _pagingController,
          limit: 10,
          pageKey: pageKey,
          state: widget.state,
          countryISO: widget.countryISO);
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
            centerTitle: true),
        body: RefreshIndicator(
            onRefresh: () async {
              _pagingController.refresh();
            },
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(
                  child: Card(
                      child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${member.placemark.administrativeArea} state'),
                      TextButton.icon(
                          onPressed: () => context.push(Routes.createCommunity),
                          icon: const Icon(Icons.add_circle),
                          label: const Text('add community'))
                    ]),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search communities',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Communities'),
                      TextButton(
                          onPressed: () {},
                          child: Text('view all states',
                              style: TextStyle(color: Style.primaryColor)))
                    ])
              ]))),
              PagedSliverGrid<DocumentSnapshot?, Community>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Community>(
                    itemBuilder: (context, community, index) =>
                        CommunityWidget(community: community),
                    noItemsFoundIndicatorBuilder: (_) => const MesssageScreen(
                          message: 'No communities found',
                          icon: Icon(Icons.search_off),
                        )),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 100 / 150,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                ),
              )
            ])));
  }
}
