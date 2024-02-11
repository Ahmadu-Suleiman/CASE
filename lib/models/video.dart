import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class Video {
  XFile file;
  late Uint8List? videoThumbnail;

  Video(this.file, this.videoThumbnail);
  Video.onlyFile(this.file);
}
