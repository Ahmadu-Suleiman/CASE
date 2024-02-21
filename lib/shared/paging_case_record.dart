import 'package:flutter/material.dart';
import 'package:case_be_heard/custom_widgets/case_card.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/services/databases/case_database.dart';
import 'package:flutter/material.dart';
import 'package:case_be_heard/custom_widgets/community_widget.dart';
import 'package:case_be_heard/custom_widgets/message_screen.dart';
import 'package:case_be_heard/models/community.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/services/databases/community_database.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class PagingCaseRecord extends StatefulWidget {
  final Function fetchCaseRecords;
  const PagingCaseRecord({super.key, required this.fetchCaseRecords});

  @override
  State<PagingCaseRecord> createState() => _PagingCaseRecordState();
}

class _PagingCaseRecordState extends State<PagingCaseRecord>
    with WidgetsBindingObserver {
  final PagingController<DocumentSnapshot?, CaseRecord>
      _pagingCaseRecordController = PagingController(firstPageKey: null);

  @override
  void initState() {
    _pagingCaseRecordController.addPageRequestListener((pageKey) {
      WidgetsBinding.instance.addObserver(this);
      widget.fetchCaseRecords();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // The app has come back to the foreground, refresh the PagedListView
      _pagingCaseRecordController.refresh();
    }
  }

    @override
  void dispose() {
    _pagingCaseRecordController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
