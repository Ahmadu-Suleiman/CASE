import 'package:case_be_heard/custom_widgets/community_widget.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class CommunitiesStatesPageWidget extends StatefulWidget {
  final String countryISO;
  const CommunitiesStatesPageWidget({super.key, required this.countryISO});

  @override
  State<CommunitiesStatesPageWidget> createState() =>
      _CommunitiesStateWidgetState();
}

class _CommunitiesStateWidgetState extends State<CommunitiesStatesPageWidget>
    with WidgetsBindingObserver {
  final PagingController<DocumentSnapshot?, Community> _pagingController =
      PagingController(firstPageKey: null);

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return FutureBuilder(
        future: DatabaseCommunity.getUniqueStates(widget.countryISO),
        builder: (BuildContext context, AsyncSnapshot<Set<String>> snapshot) {
          if (snapshot.hasData) {
            final states = snapshot.data!;
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(widget.countryISO),
                              CountryFlag.fromCountryCode(widget.countryISO,
                                  height: 48, width: 62, borderRadius: 8)
                            ]),
                        const TextField(
                            decoration: InputDecoration(
                                hintText: 'Search state',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.search))),
                        const Divider(),
                      ]))),
                      PagedSliverList<DocumentSnapshot?, Community>(
                          pagingController: _pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Community>(
                              itemBuilder: (context, community, index) =>
                                  CommunityWidget(
                                      community: community,
                                      onChoose: () => context.push(
                                          '${Routes.mainCommunityPage}/${community.id}')),
                              noItemsFoundIndicatorBuilder: (_) =>
                                  const MesssageScreen(
                                      message: 'No communities found',
                                      icon: Icon(Icons.search_off))))
                    ])));
          } else {
            return const Loading();
          }
        });
  }
}
