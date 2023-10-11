import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_cupertino_vision_platform_interface.dart';
import 'models.dart';

/// An implementation of [FlutterCupertinoVisionPlatform] that uses method channels.
class MethodChannelFlutterCupertinoVision
    extends FlutterCupertinoVisionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(
    'flutter_cupertino_vision',
  );

  @override
  Future<Map<dynamic, dynamic>?> imageToText(
      Uint8List imageData, ImageOrientation orientation) async {
    var result = await methodChannel.invokeMethod("imageToText",
        {"imageData": imageData, "orientation": orientation.toShortString()});

    Map<dynamic, dynamic> res = result;
    return res;
  }

  @override
  Future<List<VNRecognizedTextObservation>?> extractTextboxesFromImage(
      Uint8List imageData, ImageOrientation orientation) async {
    List<dynamic>? extracteText = await methodChannel.invokeListMethod(
        "extractTextboxesFromImage",
        {"imageData": imageData, "orientation": orientation.toShortString()});
    List<VNRecognizedTextObservation> data = [];
    try {
      for (var i = 0; i < imageData.length; i++) {
        Map<String, dynamic> one = Map.from(extracteText![i]);
        data.add(VNRecognizedTextObservation.fromMap(one));
      }
    } catch (error) {
      if (error.toString().contains("Invalid value: Not in inclusive range")) {
        return data;
      } else {
        throw Exception(error.toString());
      }
    }
    return data;
  }
}
