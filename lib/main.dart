import 'package:flutter/material.dart';
import 'case_card.dart';

void main() {
  runApp(HomeWidget());
}

class HomeWidget extends StatefulWidget {
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<String> texts = [
    'Thy role of the parser, Context-free grammars Writing a grammar, Top-down parsing',
    'Thy role of the parser, Context-free grammars Writing a grammar, Top-down parsing',
    'Thy role of the parser, Context-free grammars Writing a grammar, Top-down parsing',
    'Thy role of the parser, Context-free grammars Writing a grammar, Top-down parsing',
    'Thy role of the parser, Context-free grammars Writing a grammar, Top-down parsing',
    'Thy role of the parser, Context-free grammars Writing a grammar, Top-down parsing',
    'Thy role of the parser, Context-free grammars Writing a grammar, Top-down parsing',
    'Thy role of the parser, Context-free grammars Writing a grammar, Top-down parsing',
  ];

  Widget template(text) {
    return CaseCard(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          }),
          title: const Icon(
            Icons.home,
            color: Colors.blue,
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
              padding: const EdgeInsets.only(left: 5),
              children: <Widget>[
                const UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  accountName: Text(
                    'Abdulhamid Gent',
                    style: TextStyle(color: Colors.black),
                  ),
                  accountEmail: Text(
                    'gent1226@gmail',
                    style: TextStyle(color: Colors.black),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.png'),
                    radius: 60,
                  ),
                ),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Item 2'),
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
        body: ListView.builder(
            itemCount: texts.length,
            itemBuilder: (context, index) {
              return template(texts[index]);
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
