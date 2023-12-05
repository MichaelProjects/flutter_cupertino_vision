import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_vision/flutter_cupertino_vision.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

Future<InputImageData> createInputImageDataFromXFile(XFile file) async {
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
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterCupertinoVisionPlugin = FlutterCupertinoVisionKit();

  @override
  void initState() {
    super.initState();
  }

  String content = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Center(
                  child: TextButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        var transformedImage =
                            await createInputImageDataFromXFile(image!);
                        var x = await _flutterCupertinoVisionPlugin
                            .extractTextFromImage(
                                transformedImage.data,
                                transformedImage.width,
                                transformedImage.height,
                                transformedImage.orientation);

                        print(x);

                        setState(() {
                          content = x.toString();
                        });
                      },
                      child: Text("Select Image"))),
              Text(content)
            ],
          ))),
    );
  }
}
