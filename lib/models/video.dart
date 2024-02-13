import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class Video {
  XFile file;
  late Uint8List? thumbnail;

  Video(this.file, this.thumbnail);
  Video.onlyFile(this.file);
}
