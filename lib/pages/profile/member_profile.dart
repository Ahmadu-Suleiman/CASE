import 'package:case_be_heard/case_card.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/utility.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final CommunityMember member = CommunityMember.full(
      uid: '1234',
      firstName: 'Gent',
      lastName: 'Hamid',
      email: 'genthamid@gmail.com',
      phoneNumber: '080239832774',
      occupation: 'Student',
      location: 'Kaduna, NIgeria',
      gender: 'Male',
      imageUrl: 'assets/child3.jpg',
      bio:
          'I am a student who is passionate about helping my fellow studentd for a better tomorrow');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          CircleAvatar(
            backgroundImage: AssetImage(member.imageUrl),
            radius: 50,
          ),
          Text(
            '${member.firstName} ${member.lastName} ',
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.email),
            label: Text(
              member.email,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.phone),
            label: Text(
              member.phoneNumber,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.work),
            label: Text(
              member.occupation,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.location_city),
            label: Text(
              member.location,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
          Text(
            member.bio,
            maxLines: 4,
          ),
          DefaultTabController(
            length: 3,
            child: Scaffold(
              body: Column(
                children: [
                  const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: 'cases'),
                      Tab(text: 'petions'),
                      Tab(text: 'media'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        ListView.builder(
                            itemCount: Utility.texts.length,
                            itemBuilder: (context, index) {
                              return CaseCard(text: Utility.texts[index]);
                            }),
                        const Text('relevant'),
                        const Text('verified'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
