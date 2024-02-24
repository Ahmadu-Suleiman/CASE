import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/members_list.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:flutter/material.dart';

class CaseReadsWidget extends StatefulWidget {
  final String caseRecordId;
  const CaseReadsWidget({super.key, required this.caseRecordId});

  @override
  State<CaseReadsWidget> createState() => _CaseReadsState();
}

class _CaseReadsState extends State<CaseReadsWidget> {
  List<CommunityMember> membersRead = [];
  bool isLoading = true;

  @override
  void initState() {
    setup();
    super.initState();
  }

  void setup() async {
    DatabaseCase.getCaseRecord(widget.caseRecordId).then((caseRecord) {
      DatabaseMember.getCommunityMembersByIds(caseRecord.readIds)
          .then((members) {
        membersRead.addAll(members);
        setState(() => isLoading = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
                title: const Text('Read by', style: TextStyle(fontSize: 25))),
            body: ListView(children: [
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: membersRead.length,
                  itemBuilder: (BuildContext context, int index) {
                    final member = membersRead[index];
                    return MembersListWidget(member: member);
                  })
            ]));
  }
}
