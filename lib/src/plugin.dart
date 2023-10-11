import 'dart:typed_data';

import 'package:flutter_cupertino_vision/src/models.dart';

import '../flutter_cupertino_vision.dart';
import 'flutter_cupertino_vision_platform_interface.dart';

class FlutterCupertinoVision implements FlutterCupertinoVisionPlatform {
  Future<Map<dynamic, dynamic>?> imageToText(
      Uint8List imageData, ImageOrientation orientation) {
    return FlutterCupertinoVisionPlatform.instance
        .imageToText(imageData, orientation);
  }

  @override
  Future<List<VNRecognizedTextObservation>?> extractTextboxesFromImage(
      Uint8List imageData, ImageOrientation orientation) {
    return FlutterCupertinoVisionPlatform.instance
        .extractTextboxesFromImage(imageData, orientation);
  }
}
