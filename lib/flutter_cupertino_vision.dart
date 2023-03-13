library flutter_cupertino_vision;

export 'src/models.dart' show ImageOrientation;

import 'src/flutter_cupertino_vision_platform_interface.dart';
import 'src/models.dart';
import 'dart:typed_data';

class FlutterCupertinoVision {
  Future<List<String>?> imageToText(
      Uint8List imageData, ImageOrientation orientation) {
    return FlutterCupertinoVisionPlatform.instance
        .imageToText(imageData, orientation);
  }
}
