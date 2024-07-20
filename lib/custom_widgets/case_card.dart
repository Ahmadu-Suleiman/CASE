import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/shared/case_helper.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class CaseCard extends StatelessWidget {
  const CaseCard({
    super.key,
    required this.caseRecord,
  });

  final CaseRecord caseRecord;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.push('${Routes.casePage}/${caseRecord.id}'),
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
                                  style: const TextStyle(fontSize: 16)))),
                      Row(children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedAvatar(
                                url: caseRecord.member.photoUrl,
                                size: 30,
                                onPressed: () => context.push(
                                    '${Routes.memberProfileOthers}/${caseRecord.uidMember}'))),
                        const SizedBox(height: 10),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  Utility.getFirstAndlastName(
                                      caseRecord.member),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              Text(
                                caseRecord.member.placemark.administrativeArea!,
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                  CaseHelper.verified(
                                      caseRecord.member.verified),
                                  style:
                                      Theme.of(context).textTheme.titleMedium)
                            ])
                      ]),
                      const SizedBox(height: 8),
                      RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                            const TextSpan(text: 'Progress: '),
                            TextSpan(
                                text: caseRecord.progress,
                                style: Theme.of(context).textTheme.titleMedium)
                          ])),
                      RichText(
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                            const TextSpan(text: 'Type: '),
                            TextSpan(
                                text: caseRecord.type,
                                style: Theme.of(context).textTheme.titleLarge)
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
                              maxLines: 4,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayLarge)),
                      const SizedBox(height: 12),
                      Text(caseRecord.summary,
                          maxLines: 3,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge)),
                                  TextButton.icon(
                                      onPressed: () => context.push(
                                          '${Routes.caseReads}/${caseRecord.id}'),
                                      icon: const Icon(Icons.mark_chat_read),
                                      label: Text(
                                          caseRecord.readIds.length.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge))
                                ]),
                            TextButton.icon(
                                onPressed: () => context.push(
                                    '${Routes.casePage}/${caseRecord.id}'),
                                icon: const Icon(Icons.comment),
                                label: Text(caseRecord.commentCount.toString(),
                                    style:
                                        Theme.of(context).textTheme.labelLarge))
                          ])
                    ]))));
  }
}
