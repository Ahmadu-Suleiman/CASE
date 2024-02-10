class CaseRecord {
  String uidMember,
      title,
      shortDescription,
      detailedDescription,
      mainImage = '';
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
  CaseRecord.createCase(this.uidMember, this.title, this.shortDescription,
      this.detailedDescription, this.mainImage);
}