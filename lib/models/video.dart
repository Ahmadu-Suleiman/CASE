import 'dart:io';
import 'dart:typed_data';

class Video {
  File? file;
  String? videoLink;
  Uint8List? thumbnail;
  String? thumbnailUrl;

  Video(this.file, this.thumbnail);
  Video.fromCase(this.videoLink, this.thumbnailUrl);
}
