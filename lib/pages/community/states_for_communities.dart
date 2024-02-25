import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/state_for_communities_widget.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

class StatesForCommunitiesPage extends StatefulWidget {
  final String countryISO;
  const StatesForCommunitiesPage({super.key, required this.countryISO});

  @override
  State<StatesForCommunitiesPage> createState() => _CommunitiesStateWidget();
}

class _CommunitiesStateWidget extends State<StatesForCommunitiesPage>
    with WidgetsBindingObserver {
  final _searchController = TextEditingController();
  String searchText = '';
  final Set<String> _uniqueStates = {};
  List<String> _filteredStates = [];

  @override
  void initState() {
    super.initState();
    setup();
  }

  void setup() async {
    final states = await DatabaseCommunity.getUniqueStates(widget.countryISO);
    _uniqueStates.addAll(states);
    _filteredStates = _uniqueStates.toList();
    _searchController.addListener(() {
      String query = _searchController.text.toLowerCase();
      setState(() {
        _filteredStates = _uniqueStates
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _uniqueStates.isNotEmpty
        ? Scaffold(
            appBar: AppBar(
                title: const Text('States',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                centerTitle: true),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(children: [
                  Card(
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(widget.countryISO,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  CountryFlag.fromCountryCode(widget.countryISO,
                                      height: 30, width: 30, borderRadius: 16)
                                ]),
                            const SizedBox(height: 8),
                            TextField(
                                controller: _searchController,
                                style: const TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                    hintText: 'Search communities',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))),
                                    prefixIcon: Icon(Icons.search)))
                          ]))),
                  ..._filteredStates.map((state) => StatesForCommunitiesWidget(
                      state: state, countryISO: widget.countryISO))
                ])))
        : const Loading();
  }
}
