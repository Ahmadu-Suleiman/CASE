import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    CommunityMember member = Provider.of<CommunityMember>(context);
    return Scaffold(
      body: Material(
        child: Center(
          child: Column(children: [
            CircleAvatar(
              backgroundImage: Utility.getProfileImage(member.photoUrl),
              radius: 50,
            ),
            Text(
              '${member.firstName} ${member.lastName}',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushNamed(context, '/edit_member_profile');
              },
              child: const Text('Update community member information'),
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
              icon: const Icon(Icons.location_on),
              label: Text(
                member.location.join(','),
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
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Scaffold(
                  body: Column(
                    children: [
                      const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(text: 'Cases'),
                          Tab(text: 'Petitions'),
                          Tab(text: 'Media'),
                        ],
                      ),
                      TabBarView(
                        children: [
                          Text(
                            member.bio,
                          ),
                          Text(
                            member.bio,
                          ),
                          Text(
                            member.bio,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
