import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/custom_widgets/loading.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    DatabaseCase.getAllReadIds(widget.caseRecordId).then((readIds) {
      DatabaseMember.getCommunityMembersByIds(readIds).then((members) {
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
            body: Column(children: [
            const Text('Create a new Case',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListView.builder(
                shrinkWrap: true,
                itemCount: membersRead.length,
                itemBuilder: (BuildContext context, int index) {
                  final member = membersRead[index];
                  return SizedBox(
                    width: double.infinity,
                    child: ListTile(
                        leading: CachedAvatar(
                          url: member.photoUrl,
                          onPressed: () => context.push(
                              '${Routes.memberProfileOthers}/${member.uid}'),
                        ),
                        title: Text(Utility.getFirstAndlastName(member),
                            maxLines: 1),
                        subtitle: Text(member.occupation, maxLines: 1)),
                  );
                })
          ]));
  }
}
