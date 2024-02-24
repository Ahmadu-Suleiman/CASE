import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class CaseCardEdit extends StatelessWidget {
  const CaseCardEdit({
    super.key,
    required this.caseRecord,
    required this.update,
  });

  final CaseRecord caseRecord;
  final Function update;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context
              .push('${Routes.editCase}/${caseRecord.id}')
              .then((value) => update());
        },
        child: Card(
            color: Colors.white,
            margin: const EdgeInsets.all(10),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Uploaded ${timeago.format(caseRecord.dateCreated.toDate())}',
                                style: const TextStyle(fontSize: 16),
                              ))),
                      RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                            const TextSpan(text: 'Progress: '),
                            TextSpan(
                                text: caseRecord.progress,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Style.primaryColor))
                          ])),
                      RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                            const TextSpan(text: 'Type: '),
                            TextSpan(
                                text: caseRecord.type,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Style.primaryColor))
                          ])),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                  imageUrl: caseRecord.mainImage,
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const Icon(Icons.image),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error)))),
                      Center(
                          child: Text(caseRecord.title,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                      const SizedBox(height: 12),
                      Text(caseRecord.summary,
                          maxLines: 4,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18.0, color: Colors.black)),
                      const Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton.icon(
                                      onPressed: () => context.push(
                                          '${Routes.caseViews}/${caseRecord.id}'),
                                      icon: const Icon(Icons.remove_red_eye),
                                      label: Text(
                                          caseRecord.viewIds.length.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                          ))),
                                  TextButton.icon(
                                      onPressed: () => context.push(
                                          '${Routes.caseReads}/${caseRecord.id}'),
                                      icon: const Icon(Icons.mark_chat_read),
                                      label: Text(
                                          caseRecord.readIds.length.toString(),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue)))
                                ]),
                            TextButton.icon(
                                onPressed: () => context.push(
                                    '${Routes.casePage}/${caseRecord.id}'),
                                icon: const Icon(Icons.comment),
                                label: Text(caseRecord.commentCount.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Style.primaryColor)))
                          ])
                    ]))));
  }
}
