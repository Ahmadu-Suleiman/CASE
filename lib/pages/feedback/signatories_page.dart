import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/members_list.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/databases/petition_database.dart';
import 'package:flutter/material.dart';

class SignatoriesWidget extends StatefulWidget {
  final String petitionId;
  const SignatoriesWidget({super.key, required this.petitionId});

  @override
  State<SignatoriesWidget> createState() => _CaseReadsState();
}

class _CaseReadsState extends State<SignatoriesWidget> {
  List<CommunityMember> membersSigned = [];
  bool isLoading = true;

  @override
  void initState() {
    setup();
    super.initState();
  }

  void setup() async {
    DatabasePetition.getPetition(widget.petitionId).then((petition) {
      DatabaseMember.getCommunityMembersByIds(petition.signatoryIds)
          .then((members) {
        membersSigned.addAll(members);
        setState(() => isLoading = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            body: ListView(children: [
            const Text('Reads',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: membersSigned.length,
                itemBuilder: (BuildContext context, int index) {
                  final member = membersSigned[index];
                  return MembersListWidget(member: member);
                })
          ]));
  }
}
