import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class Video {
  XFile file;
  Uint8List videoThumbnail;

  Video(this.file, this.videoThumbnail);
}
