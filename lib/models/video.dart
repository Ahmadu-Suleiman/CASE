import 'dart:io';
import 'dart:typed_data';

class Video {
  File? file;
  String? videoUrl;
  Uint8List? thumbnail;
  String? thumbnailUrl;

  Video(this.file, this.thumbnail);
  Video.fromCase(this.videoUrl, this.thumbnailUrl);
}
