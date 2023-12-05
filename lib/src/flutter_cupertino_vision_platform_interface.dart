import 'dart:typed_data';

import 'package:flutter_cupertino_vision/src/image_processing_api.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_cupertino_vision_method_channel.dart';

abstract class FlutterCupertinoVisionPlatform extends PlatformInterface {
  /// Constructs a FlutterCupertinoVisionPlatform.
  FlutterCupertinoVisionPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterCupertinoVisionPlatform _instance = FlutterCupertinoVisionKit();

  /// The default instance of [FlutterCupertinoVisionPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterCupertinoVision].
  static FlutterCupertinoVisionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterCupertinoVisionPlatform] when
  /// they register themselves.
  static set instance(FlutterCupertinoVisionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<VisionResponse?>> extractTextFromImage(
      Uint8List imageData, int width, int height, ImageOrientation orientation);

  Future<List<VisionResponse?>> documentDetection(
      Uint8List imageData, int width, int height, ImageOrientation orientation);
}
