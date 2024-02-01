class Case {
  String title, shortDescription, detailedDescription, mainImage;
  late List<String> photos, videos, audios, links;

  Case(this.title, this.shortDescription, this.detailedDescription,
      this.mainImage, this.photos, this.videos, this.audios, this.links);
  Case.createCase(this.title, this.shortDescription, this.detailedDescription,
      this.mainImage);
}
