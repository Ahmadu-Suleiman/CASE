import 'package:case_be_heard/custom_widgets/community_widget.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CommunitiesPageWidget extends StatefulWidget {
  final String state;
  final String countryISO;
  const CommunitiesPageWidget(
      {super.key, required this.state, required this.countryISO});

  @override
  State<CommunitiesPageWidget> createState() => _CommunitiesWidgetState();
}

class _CommunitiesWidgetState extends State<CommunitiesPageWidget> {
  final _searchController = TextEditingController();
  final List<Community> commuities = [];
  List<Community> filteredCommunities = [];

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() async {
    final allCommunities = await DatabaseCommunity.getAllCommunitiesForState(
        countryISO: widget.countryISO, state: widget.state);
    commuities.addAll(allCommunities);
    filteredCommunities = commuities.toList();
    _searchController.addListener(() {
      String query = _searchController.text.toLowerCase();
      setState(() {
        filteredCommunities = commuities
            .where((community) => community.name.toLowerCase().contains(query))
            .toList();
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    CommunityMember member = context.watch<CommunityMember>();
    return commuities.isNotEmpty
        ? Scaffold(
            appBar: AppBar(
                title: const Text('State communities',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                centerTitle: true),
            body: Column(children: [
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${member.placemark.administrativeArea} state',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold)),
                              TextButton.icon(
                                  onPressed: () =>
                                      context.push(Routes.createCommunity),
                                  icon: const Icon(Icons.add_circle),
                                  label: Text('add community',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Style.primaryColor)))
                            ]),
                        TextField(
                            controller: _searchController,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                                hintText: 'Search communities',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                prefixIcon: Icon(Icons.search))),
                        const Divider(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Communities',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              TextButton(
                                  onPressed: () => context.push(
                                      '${Routes.statesForCommunities}/${widget.countryISO}'),
                                  child: Text('view all states',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Style.primaryColor)))
                            ])
                      ]))),
              Expanded(
                  child: ListView.builder(
                      itemCount: filteredCommunities.length,
                      itemBuilder: (context, index) {
                        Community community = filteredCommunities[index];
                        return CommunityWidget(
                            community: community,
                            onChoose: () => context.push(
                                '${Routes.mainCommunityPage}/${community.id}'));
                      }))
            ]))
        : const Loading();
  }
}
