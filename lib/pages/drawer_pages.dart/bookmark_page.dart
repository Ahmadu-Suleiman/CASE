import 'package:flutter/material.dart';

class BookmarkWidget extends StatefulWidget {
  const BookmarkWidget({super.key});

  @override
  State<BookmarkWidget> createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Cases'),
              Tab(text: 'Petitions'),
            ],
          ),
          title: const Text('Bookmarks',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              )),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Content for Tab  2')),
          ],
        ),
      ),
    );
  }
}
