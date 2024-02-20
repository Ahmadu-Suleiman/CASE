import 'package:cached_network_image/cached_network_image.dart';
import 'package:case_be_heard/models/community_member.dart';
import 'package:case_be_heard/models/petition.dart';
import 'package:case_be_heard/services/databases/member_database.dart';
import 'package:case_be_heard/services/databases/petition_database.dart';
import 'package:case_be_heard/shared/petition_helper.dart';
import 'package:case_be_heard/shared/routes.dart';
import 'package:case_be_heard/shared/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class PetitionCard extends StatefulWidget {
  const PetitionCard({super.key, required this.petition, required this.member});

  final CommunityMember member;
  final Petition petition;

  @override
  State<PetitionCard> createState() => _PetitionCardState();
}

class _PetitionCardState extends State<PetitionCard> {
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
                    child: Text(
                      widget.petition.title,
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
                    widget.petition.description,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  LinearProgressBar(
                    maxSteps: widget.petition.target,
                    progressType: LinearProgressBar
                        .progressTypeLinear, // Use Linear progress
                    currentStep: widget.petition.signatoryIds.length,
                    progressColor: Style.primaryColor,
                    backgroundColor: Style.secondaryColor,
                  ),
                  GestureDetector(
                    onTap: () => context
                        .push('${Routes.signatories}/${widget.petition.id}'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                                widget.petition.signatoryIds.length.toString()),
                            const Text('Signatures')
                          ],
                        ),
                        Column(
                          children: [
                            Text(widget.petition.target.toString()),
                            const Text('Target Signatures')
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(children: [
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if (!_isSigned()) _sign();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Style.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12), // Padding
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            child: _isSigned()
                                ? const Text('Signed',
                                    style: TextStyle(color: Colors.white))
                                : const Text('Sign this peition',
                                    style: TextStyle(color: Colors.white))))
                  ]),
                  const Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: const Icon(Icons.bookmark),
                            color: PetitionHelper.isBookmark(
                                    widget.member, widget.petition)
                                ? Style.primaryColor
                                : Colors.black,
                            onPressed: () async {
                              if (PetitionHelper.isBookmark(
                                  widget.member, widget.petition)) {
                                await DatabaseMember.addBookmarkPetition(
                                    widget.member, widget.petition);
                              } else {
                                await DatabaseMember.removeBookmarkPetition(
                                    widget.member, widget.petition);
                              }
                              setState(() {});
                            }),
                        IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              //TODO: Add your logic here
                            })
                      ])
                ])));
  }

  bool _isSigned() {
    return widget.petition.signatoryIds.contains(widget.member.id);
  }

  void _sign() async {
    DatabasePetition.addSignature(widget.member.id!, widget.petition).then(
        (_) => DatabasePetition.getPetition(widget.petition.id).then(
            (petition) => setState(
                () => widget.petition.signatoryIds = petition.signatoryIds)));
  }
}
