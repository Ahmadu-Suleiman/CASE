import 'package:flutter/material.dart';

void main() {
  runApp(HomeWidget());
}

class HomeWidget extends StatefulWidget {
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  List<String> texts = [
    'The role of the parser, Context-free grammars',
    'The role of the parser, Context-free grammars',
    'The role of the parser, Context-free grammars',
    'The role of the parser, Context-free grammars',
    'The role of the parser, Context-free grammars',
    'The role of the parser, Context-free grammars',
    'The role of the parser, Context-free grammars'
  ];

  Widget template(text) {
    return Card(
      margin: const EdgeInsets.all(30),
      child: Column(children: <Widget>[
        const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
              radius: 30,
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Gent',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'genthamid@gmail.com',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Verified Case',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Image(
            image: AssetImage('assets/profile.png'),
            width: 250,
            height: 250,
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 18.0, color: Colors.black),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Salimated',
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
      ]),
    );
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
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Text('Drawer Header'),
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
