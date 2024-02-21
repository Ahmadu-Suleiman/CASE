import 'package:cloud_firestore/cloud_firestore.dart';

class Community {
  late String id;
  late Timestamp dateCreated;
  String name;
  List<String> adminIds;
  List<String> memberIds;
  String description;
  String regulations;
  String image;
  String state;
  String countryISO;

  Community.forUpload(
      {required this.name,
      required this.dateCreated,
      required this.adminIds,
      required this.memberIds,
      required this.description,
      required this.regulations,
      required this.image,
      required this.state,
      required this.countryISO});
  Community(
      {required this.id,
      required this.name,
      required this.dateCreated,
      required this.adminIds,
      required this.memberIds,
      required this.description,
      required this.regulations,
      required this.image,
      required this.state,
      required this.countryISO});
}
