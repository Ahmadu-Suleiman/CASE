import 'package:flutter/material.dart';

class CasePage extends StatefulWidget {
  const CasePage({super.key});

  @override
  State<CasePage> createState() => _CasePageState();
}

class _CasePageState extends State<CasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Image(
            height: 80,
            width: 80,
            image: AssetImage('assets/case_logo_main.ico'),
            color: Colors.brown,
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.bookmark),
              onPressed: () {
                // Add your logic here
              },
            ),
          ],
        ),
        body: const DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Column(
              children: [
                TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: 'others'),
                    Tab(text: 'relevant'),
                    Tab(text: 'verified'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Text('others'),
                      Text('relevant'),
                      Text('verified'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ) // Add other widgets here
        );
  }
}
