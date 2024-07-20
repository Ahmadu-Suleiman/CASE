import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class PetitionCardEdit extends StatefulWidget {
  const PetitionCardEdit(
      {super.key,
      required this.petition,
      required this.member,
      required this.onDelete});

  final CommunityMember member;
  final Petition petition;
  final Function onDelete;

  @override
  State<PetitionCardEdit> createState() => _PetitionCardState();
}

class _PetitionCardState extends State<PetitionCardEdit> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                            'Uploaded ${timeago.format(widget.petition.dateCreated.toDate())}',
                            style: const TextStyle(fontSize: 16),
                          ))),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: CachedNetworkImage(
                            imageUrl: widget.petition.image,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const Icon(Icons.image),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ))),
                  Center(
                      child: Text(widget.petition.title,
                          maxLines: 4,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black))),
                  const SizedBox(height: 12),
                  Text(widget.petition.description,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.black)),
                  LinearProgressBar(
                      maxSteps: widget.petition.target,
                      progressType: LinearProgressBar
                          .progressTypeLinear, // Use Linear progress
                      currentStep: widget.petition.signatoryIds.length,
                      progressColor: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary),
                  GestureDetector(
                      onTap: () => context
                          .push('${Routes.signatories}/${widget.petition.id}'),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              Text(
                                widget.petition.signatoryIds.length.toString(),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              Text('Signatures',
                                  style: Theme.of(context).textTheme.labelLarge)
                            ]),
                            Column(children: [
                              Text(widget.petition.target.toString()),
                              const Text('Target Signatures')
                            ])
                          ])),
                  const Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                            child: IconButton(
                                icon: const Icon(Icons.delete_forever),
                                onPressed: () {
                                  _deletePetition().then((delete) {
                                    if (delete) widget.onDelete;
                                  });
                                }))
                      ])
                ])));
  }

  Future<bool> _deletePetition() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Delete peition'),
              content: const Text('Are you sure want to delete this petition'),
              actions: <Widget>[
                TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      Navigator.pop(context, true);
                    }),
                TextButton(
                    child: const Text('cancel'),
                    onPressed: () {
                      Navigator.pop(context, true);
                    })
              ]);
        });
  }
}
