import 'package:pigeon/pigeon.dart';

// #docregion config
enum ImageOrientation { up, down, left, right }

class InputImageData {
  InputImageData(this.width, this.height, this.orientation, this.data);

  int width;
  int height;
  ImageOrientation orientation;
  Uint8List data;
}

class BoundingBox {
  double left;
  double top;
  double width;
  double height;
  BoundingBox(this.left, this.top, this.width, this.height);
}

class VisionResponse {
  BoundingBox boundingBox;
  double confidence;
  List<String?> candiates;
  VisionResponse(this.boundingBox, this.confidence, this.candiates);
}

@HostApi()
abstract class ImageProcessingApi {
  @async
  List<VisionResponse> imageToText(InputImageData imageData);

  @async
  List<VisionResponse> documentDetection(InputImageData imageData);
}
// #enddocregion host-definitions