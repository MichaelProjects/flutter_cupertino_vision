import 'package:flutter/material.dart';
import 'package:flutter_cupertino_vision/flutter_cupertino_vision.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterCupertinoVisionPlugin = FlutterCupertinoVision();

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
          body: Column(
            children: [
              Center(
                  child: TextButton(
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        var data = await image!.readAsBytes();
                        var x = await _flutterCupertinoVisionPlugin.imageToText(
                            data, ImageOrientation.up);
                        print("abc test");
                        setState(() {
                          content = x.toString();
                        });
                      },
                      child: Text("Select Image"))),
              Text(content)
            ],
          )),
    );
  }
}
