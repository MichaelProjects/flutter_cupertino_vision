import 'dart:typed_data';

import '../flutter_cupertino_vision.dart';
import 'flutter_cupertino_vision_platform_interface.dart';

class FlutterCupertinoVision {
  Future<Map<dynamic, dynamic>?> imageToText(
      Uint8List imageData, ImageOrientation orientation) {
    return FlutterCupertinoVisionPlatform.instance
        .imageToText(imageData, orientation);
  }
}
