import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_cupertino_vision_platform_interface.dart';
import 'models.dart';

/// An implementation of [FlutterCupertinoVisionPlatform] that uses method channels.
class MethodChannelFlutterCupertinoVision
    extends FlutterCupertinoVisionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_cupertino_vision');

  @override
  Future<Map<dynamic, dynamic>?> imageToText(
      Uint8List imageData, ImageOrientation orientation) async {
    var result = await methodChannel.invokeMethod("imageToText",
        {"imageData": imageData, "orientation": orientation.toShortString()});

    Map<dynamic, dynamic> res = result;
    return res;
  }
}
