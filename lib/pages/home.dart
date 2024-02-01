import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:case_be_heard/case_card.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int bottomNavIndex = 0;

  List<String> texts = [
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
    'John Doe went missing three days ago. If you have any information or have seen him, please contact the nearest police station immediately.',
  ];

  Widget template(text) {
    return CaseCard(text: text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        title: const Image(
          height: 80,
          width: 80,
          image: AssetImage('assets/case_logo_main.ico'),
          color: Colors.brown,
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
                title: const Text('Case catalog'),
                leading: const Icon(Icons.folder),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Communities'),
                leading: const Icon(Icons.people),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Help'),
                leading: const Icon(Icons.help),
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
        onPressed: () => Navigator.pushNamed(context, '/create_case'),
        shape: const CircleBorder(),
        splashColor: Colors.brown,
        child: const Icon(
          Icons.add,
          color: Colors.brown,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const <IconData>[
          Icons.home,
          Icons.notifications,
          Icons.message,
          Icons.ondemand_video,
        ],
        activeIndex: bottomNavIndex,
        gapLocation: GapLocation.center,
        notchMargin: 8,
        notchSmoothness: NotchSmoothness.sharpEdge,
        onTap: (index) => setState(() => bottomNavIndex = index),
      ),
    );
  }
}
