import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cupertino_vision/flutter_cupertino_vision.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:image/image.dart' as img;

Future<InputImageData> createInputImageDataFromFile(File file) async {
  // Read the file into a Uint8List
  Uint8List fileData = await file.readAsBytes();

  // Decode the image to get width and height
  img.Image? image = img.decodeImage(fileData);
  if (image == null) throw Exception('Unable to decode image');

  // Simplified orientation determination
  // This part of the code can be expanded to analyze EXIF data for more accuracy
  ImageOrientation orientation;
  if (image.width > image.height) {
    orientation = ImageOrientation.right; // or left, depending on your criteria
  } else {
    orientation = ImageOrientation.up; // or down, depending on your criteria
  }

  // Create the InputImageData instance
  return InputImageData(
    width: image.width,
    height: image.height,
    orientation: orientation,
    data: fileData,
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("detect document in image", (WidgetTester tester) async {
    var inputImage = await createInputImageDataFromFile(File(
        "/Users/michael/Development/workspaces/flutter_cupertino_vision/integration_test/assets/bon1.png"));
    var res = await ImageProcessingApi().documentDetection(inputImage);
    print(res);
    assert(false);
  });
}
