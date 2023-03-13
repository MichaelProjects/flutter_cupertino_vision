import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_cupertino_vision_method_channel.dart';
import 'models.dart';

abstract class FlutterCupertinoVisionPlatform extends PlatformInterface {
  /// Constructs a FlutterCupertinoVisionPlatform.
  FlutterCupertinoVisionPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterCupertinoVisionPlatform _instance =
      MethodChannelFlutterCupertinoVision();

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

  Future<List<String>?> imageToText(
      Uint8List imageData, ImageOrientation orientation) async {
    throw UnimplementedError('imageToText() has not been implemented.');
  }
}
