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
  @override
  Widget build(BuildContext context) {
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
                body: ListView(children: [
                  Card(
                      child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Text(widget.countryISO,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      CountryFlag.fromCountryCode(widget.countryISO,
                          height: 30, width: 30, borderRadius: 8)
                    ]),
                    const TextField(
                        decoration: InputDecoration(
                            hintText: 'Search state',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search))),
                    const Divider(),
                    const Text('States')
                  ])),
                  ...states.map((state) => StatesForCommunitiesWidget(
                      state: state, countryISO: widget.countryISO))
                ]));
          } else {
            return const Loading();
          }
        });
  }
}
