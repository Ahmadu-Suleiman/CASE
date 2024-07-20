import 'package:case_be_heard/custom_widgets/community_widget.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:case_be_heard/shared/routes.dart';
// import 'package:case_be_heard/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CommunitiesFromStatePage extends StatefulWidget {
  final String state;
  final String countryISO;
  const CommunitiesFromStatePage(
      {super.key, required this.state, required this.countryISO});

  @override
  State<CommunitiesFromStatePage> createState() => _CommunityFromStateState();
}

class _CommunityFromStateState extends State<CommunitiesFromStatePage>
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
                Text('${widget.state} state'),
                const TextField(
                    decoration: InputDecoration(
                        hintText: 'Search communities',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search))),
                const Divider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Communities'),
                      TextButton(
                          onPressed: () => context.push(
                              '${Routes.statesForCommunities}/${widget.countryISO}'),
                          child: const Text('view all states',
                              ))
                    ])
              ]))),
              PagedSliverList<DocumentSnapshot?, Community>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Community>(
                      itemBuilder: (context, community, index) => CommunityWidget(
                          community: community,
                          onChoose: () => context.push(
                              '${Routes.mainCommunityPage}/${community.id}')),
                      noItemsFoundIndicatorBuilder: (_) => const MesssageScreen(
                          message: 'No communities found',
                          icon: Icon(Icons.search_off))))
            ])));
  }
}
