import 'dart:typed_data';

import 'package:flutter_cupertino_vision/src/flutter_cupertino_vision_method_channel.dart';
import 'package:flutter_cupertino_vision/src/flutter_cupertino_vision_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cupertino_vision/flutter_cupertino_vision.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterCupertinoVisionPlatform
    with MockPlatformInterfaceMixin
    implements FlutterCupertinoVisionPlatform {
  @override
  Future<List> extractTextboxesFromImage(Uint8List imageData, ImageOrientation orientation) {
    // TODO: implement extractTextboxesFromImage
    throw UnimplementedError();
  }

  @override
  Future<Map?> imageToText(Uint8List imageData, ImageOrientation orientation) {
    // TODO: implement imageToText
    throw UnimplementedError();
  }
}

void main() {
  final FlutterCupertinoVisionPlatform initialPlatform =
      FlutterCupertinoVisionPlatform.instance;

  test('$MethodChannelFlutterCupertinoVision is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelFlutterCupertinoVision>());
  });

  test('getPlatformVersion', () async {
    FlutterCupertinoVision flutterCupertinoVisionPlugin =
        FlutterCupertinoVision();
    MockFlutterCupertinoVisionPlatform fakePlatform =
        MockFlutterCupertinoVisionPlatform();
    FlutterCupertinoVisionPlatform.instance = fakePlatform;^

    expect(await flutterCupertinoVisionPlugin.getPlatformVersion(), '42');
  });
}
