import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_vision/src/image_processing_api.dart';

import 'flutter_cupertino_vision_platform_interface.dart';

/// An implementation of [FlutterCupertinoVisionPlatform] that uses method channels.
class FlutterCupertinoVisionKit extends FlutterCupertinoVisionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(
    'flutter_cupertino_vision',
  );

  @override
  Future<List<VisionResponse?>> documentDetection(Uint8List imageData,
      int width, int height, ImageOrientation orientation) async {
    var res = await ImageProcessingApi().documentDetection(InputImageData(
        width: width,
        height: height,
        orientation: orientation,
        data: imageData));

    return res;
  }

  @override
  Future<List<VisionResponse?>> extractTextFromImage(Uint8List imageData,
      int width, int height, ImageOrientation orientation) async {
    var res = await ImageProcessingApi().imageToText(InputImageData(
        data: imageData,
        width: width,
        height: height,
        orientation: orientation));

    return res;
  }
}
