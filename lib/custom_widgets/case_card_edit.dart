import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/models/case_record.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:flutter/material.dart';

class CaseCardEdit extends StatefulWidget {
  final CaseRecord caseRecord;

  const CaseCardEdit({
    super.key,
    required this.caseRecord,
  });

  @override
  State<CaseCardEdit> createState() => _CaseCardEditState();
}

class _CaseCardEditState extends State<CaseCardEdit> {
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
      onTap: () {
        Navigator.pushNamed(context, Routes.routeEditCase,
            arguments: caseRecord.uid);
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Progress: Investigation pending',
                  style: TextStyle(
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
                    maxLines: 3,
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