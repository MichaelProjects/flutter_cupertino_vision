import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cupertino_vision/flutter_cupertino_vision_method_channel.dart';

void main() {
  MethodChannelFlutterCupertinoVision platform = MethodChannelFlutterCupertinoVision();
  const MethodChannel channel = MethodChannel('flutter_cupertino_vision');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
