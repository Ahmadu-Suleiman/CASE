import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String address = '';
  @override
  Widget build(BuildContext context) {
    CommunityMember member = Provider.of<CommunityMember>(context);
    return FutureBuilder(
        future: LocationService.getLocationAddress(member.location),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            address = snapshot.data!;
            return Center(
              child: Column(children: [
                CachedAvatar(url: member.photoUrl, size: 60),
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
                    address,
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
                  child: Column(
                    children: [
                      const TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          Tab(text: 'Cases'),
                          Tab(text: 'Petitions'),
                          Tab(text: 'Media'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
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
                      ),
                    ],
                  ),
                )
              ]),
            );
          } else {
            return const Loading();
          }
        });
  }
}
