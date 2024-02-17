import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/custom_widgets/cached_image.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class CaseCard extends StatefulWidget {
  final CaseRecord caseRecord;

  const CaseCard({
    super.key,
    required this.caseRecord,
  });

  @override
  State<CaseCard> createState() => _CaseCardState();
}

class _CaseCardState extends State<CaseCard> {
  @override
  Widget build(BuildContext context) {
    return Case(caseRecord: widget.caseRecord);
  }
}

class Case extends StatelessWidget {
  const Case({
    super.key,
    required this.caseRecord,
  });

  final CaseRecord caseRecord;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('${Routes.casePage}/${caseRecord.uid}'),
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
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedAvatar(
                            url: caseRecord.member.photoUrl, size: 30)),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Utility.getFirstAndlastName(caseRecord.member),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        FilledButton.icon(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(8)),
                              minimumSize: MaterialStateProperty.all(Size.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.message,
                              size: 12,
                            ),
                            label: const Text(
                              'Contact directly',
                              style: TextStyle(fontSize: 12),
                            )),
                        TextButton.icon(
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.verified),
                          label: const Text(
                            'ID Verified',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Progress: ${caseRecord.progress}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Type: ${caseRecord.type}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: caseRecord.mainImage,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Icon(Icons.image),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )),
                ),
                Center(
                  child: Text(
                    caseRecord.title,
                    maxLines: 4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  caseRecord.summary,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18.0, color: Colors.black),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.remove_red_eye),
                          label: const Text(
                            '148',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.mark_chat_read),
                          label: const Text(
                            '65',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Add your logic here
                      },
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
