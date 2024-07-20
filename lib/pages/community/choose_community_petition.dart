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

class ChoosePetitionCommunityPageWidget extends StatefulWidget {
  final String state;
  final String countryISO;
  const ChoosePetitionCommunityPageWidget(
      {super.key, required this.state, required this.countryISO});

  @override
  State<ChoosePetitionCommunityPageWidget> createState() =>
      _CommunityPetitionWidgetState();
}

class _CommunityPetitionWidgetState
    extends State<ChoosePetitionCommunityPageWidget> {
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
                title: const Image(
                  height: 80,
                  width: 80,
                  image: AssetImage('assets/case_logo_main.ico'),
                ),
                centerTitle: true),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      const Text('Choose community for your petition',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          )),
                      const Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${member.placemark.administrativeArea} state',
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                            TextButton.icon(
                                onPressed: () =>
                                    context.push(Routes.createCommunity),
                                icon: const Icon(Icons.add_circle),
                                label: const Text('add community',
                                    ))
                          ]),
                      TextField(
                          controller: _searchController,
                          style: const TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                              hintText: 'Search communities',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              prefixIcon: Icon(Icons.search)))
                    ]),
                  )),
                  Expanded(
                      child: ListView.builder(
                          itemCount: filteredCommunities.length,
                          itemBuilder: (context, index) {
                            Community community = filteredCommunities[index];
                            return CommunityWidget(
                                community: community,
                                onChoose: () => context.replace(
                                    '${Routes.createPetition}/${community.id}'));
                          }))
                ])))
        : const Loading();
  }
}
