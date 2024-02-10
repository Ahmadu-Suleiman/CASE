class CaseRecord {
  String uidMember, title, shortDescription, detailedDescription = '';
  String? mainImage;
  late List<String> photos, videos, audios, links = [];

  CaseRecord(
      {required this.uidMember,
      required this.title,
      required this.shortDescription,
      required this.detailedDescription,
      required this.mainImage,
      required this.photos,
      required this.videos,
      required this.audios,
      required this.links});
  CaseRecord.init(
      {required this.uidMember,
      required this.title,
      required this.shortDescription,
      required this.detailedDescription});
}
