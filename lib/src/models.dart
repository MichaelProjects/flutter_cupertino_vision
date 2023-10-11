import 'dart:ui';

enum ImageOrientation { up, down, left, right }

extension ParseToString on ImageOrientation {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class VNRecognizedTextObservation {
  final Rect boundingBox;
  final double confidence;
  final List<String> candidates;

  VNRecognizedTextObservation({
    required this.boundingBox,
    required this.confidence,
    required this.candidates,
  });

  factory VNRecognizedTextObservation.fromMap(Map<String, dynamic> map) {
    return VNRecognizedTextObservation(
      boundingBox: Rect.fromLTWH(
        map['boundingBox']['left'],
        map['boundingBox']['top'],
        map['boundingBox']['width'],
        map['boundingBox']['height'],
      ),
      confidence: map['confidence'],
      candidates: List<String>.from(map['candidates']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'boundingBox': {
        'left': boundingBox.left,
        'top': boundingBox.top,
        'width': boundingBox.width,
        'height': boundingBox.height,
      },
      'confidence': confidence,
      'candidates': candidates,
    };
  }

  List<String> topCandidates(int count) {
    return candidates.take(count).toList();
  }
}
