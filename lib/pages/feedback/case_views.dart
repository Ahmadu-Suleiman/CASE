import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/custom_widgets/members_list.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:flutter/material.dart';

class CaseViewsWidget extends StatefulWidget {
  final String caseRecordId;
  const CaseViewsWidget({super.key, required this.caseRecordId});

  @override
  State<CaseViewsWidget> createState() => _CaseViewsState();
}

class _CaseViewsState extends State<CaseViewsWidget> {
  List<CommunityMember> membersViews = [];
  bool isLoading = true;

  @override
  void initState() {
    setup();
    super.initState();
  }

  void setup() async {
    DatabaseCase.getCaseRecord(widget.caseRecordId).then((caseRecord) {
      DatabaseMember.getCommunityMembersByIds(caseRecord.viewIds)
          .then((members) {
        membersViews.addAll(members);
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
            const Text('Views',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListView.builder(
                padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemCount: membersViews.length,
                itemBuilder: (BuildContext context, int index) {
                  final member = membersViews[index];
                  return MembersListWidget(member: member);
                })
          ]));
  }
}
