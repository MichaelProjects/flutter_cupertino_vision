// Autogenerated from Pigeon (v13.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

import Foundation
#if os(iOS)
import Flutter
#elseif os(macOS)
import FlutterMacOS
#else
#error("Unsupported platform.")
#endif

private func isNullish(_ value: Any?) -> Bool {
  return value is NSNull || value == nil
}

private func wrapResult(_ result: Any?) -> [Any?] {
  return [result]
}

private func wrapError(_ error: Any) -> [Any?] {
  if let flutterError = error as? FlutterError {
    return [
      flutterError.code,
      flutterError.message,
      flutterError.details
    ]
  }
  return [
    "\(error)",
    "\(type(of: error))",
    "Stacktrace: \(Thread.callStackSymbols)"
  ]
}

private func nilOrValue<T>(_ value: Any?) -> T? {
  if value is NSNull { return nil }
  return value as! T?
}

enum ImageOrientation: Int {
  case up = 0
  case down = 1
  case left = 2
  case right = 3
}

/// Generated class from Pigeon that represents data sent in messages.
struct InputImageData {
  var width: Int64
  var height: Int64
  var orientation: ImageOrientation
  var data: FlutterStandardTypedData

  static func fromList(_ list: [Any?]) -> InputImageData? {
    let width = list[0] is Int64 ? list[0] as! Int64 : Int64(list[0] as! Int32)
    let height = list[1] is Int64 ? list[1] as! Int64 : Int64(list[1] as! Int32)
    let orientation = ImageOrientation(rawValue: list[2] as! Int)!
    let data = list[3] as! FlutterStandardTypedData

    return InputImageData(
      width: width,
      height: height,
      orientation: orientation,
      data: data
    )
  }
  func toList() -> [Any?] {
    return [
      width,
      height,
      orientation.rawValue,
      data,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
struct BoundingBox {
  var left: Double
  var top: Double
  var width: Double
  var height: Double

  static func fromList(_ list: [Any?]) -> BoundingBox? {
    let left = list[0] as! Double
    let top = list[1] as! Double
    let width = list[2] as! Double
    let height = list[3] as! Double

    return BoundingBox(
      left: left,
      top: top,
      width: width,
      height: height
    )
  }
  func toList() -> [Any?] {
    return [
      left,
      top,
      width,
      height,
    ]
  }
}

/// Generated class from Pigeon that represents data sent in messages.
public struct VisionResponse {
  var boundingBox: BoundingBox
  var confidence: Double
  var candiates: [String?]

  static func fromList(_ list: [Any?]) -> VisionResponse? {
    let boundingBox = BoundingBox.fromList(list[0] as! [Any?])!
    let confidence = list[1] as! Double
    let candiates = list[2] as! [String?]

    return VisionResponse(
      boundingBox: boundingBox,
      confidence: confidence,
      candiates: candiates
    )
  }
  func toList() -> [Any?] {
    return [
      boundingBox.toList(),
      confidence,
      candiates,
    ]
  }
}

private class ImageProcessingApiCodecReader: FlutterStandardReader {
  override func readValue(ofType type: UInt8) -> Any? {
    switch type {
      case 128:
        return BoundingBox.fromList(self.readValue() as! [Any?])
      case 129:
        return InputImageData.fromList(self.readValue() as! [Any?])
      case 130:
        return VisionResponse.fromList(self.readValue() as! [Any?])
      default:
        return super.readValue(ofType: type)
    }
  }
}

private class ImageProcessingApiCodecWriter: FlutterStandardWriter {
  override func writeValue(_ value: Any) {
    if let value = value as? BoundingBox {
      super.writeByte(128)
      super.writeValue(value.toList())
    } else if let value = value as? InputImageData {
      super.writeByte(129)
      super.writeValue(value.toList())
    } else if let value = value as? VisionResponse {
      super.writeByte(130)
      super.writeValue(value.toList())
    } else {
      super.writeValue(value)
    }
  }
}

private class ImageProcessingApiCodecReaderWriter: FlutterStandardReaderWriter {
  override func reader(with data: Data) -> FlutterStandardReader {
    return ImageProcessingApiCodecReader(data: data)
  }

  override func writer(with data: NSMutableData) -> FlutterStandardWriter {
    return ImageProcessingApiCodecWriter(data: data)
  }
}

class ImageProcessingApiCodec: FlutterStandardMessageCodec {
  static let shared = ImageProcessingApiCodec(readerWriter: ImageProcessingApiCodecReaderWriter())
}

/// Generated protocol from Pigeon that represents a handler of messages from Flutter.
protocol ImageProcessingApi {
  func imageToText(imageData: InputImageData, completion: @escaping (Result<[VisionResponse], Error>) -> Void)
  func documentDetection(imageData: InputImageData, completion: @escaping (Result<[VisionResponse], Error>) -> Void)
}

/// Generated setup class from Pigeon to handle messages through the `binaryMessenger`.
class ImageProcessingApiSetup {
  /// The codec used by ImageProcessingApi.
  static var codec: FlutterStandardMessageCodec { ImageProcessingApiCodec.shared }
  /// Sets up an instance of `ImageProcessingApi` to handle messages through the `binaryMessenger`.
  static func setUp(binaryMessenger: FlutterBinaryMessenger, api: ImageProcessingApi?) {
    let imageToTextChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flutter_cupertino_vision.ImageProcessingApi.imageToText", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      imageToTextChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let imageDataArg = args[0] as! InputImageData
        api.imageToText(imageData: imageDataArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      imageToTextChannel.setMessageHandler(nil)
    }
    let documentDetectionChannel = FlutterBasicMessageChannel(name: "dev.flutter.pigeon.flutter_cupertino_vision.ImageProcessingApi.documentDetection", binaryMessenger: binaryMessenger, codec: codec)
    if let api = api {
      documentDetectionChannel.setMessageHandler { message, reply in
        let args = message as! [Any?]
        let imageDataArg = args[0] as! InputImageData
        api.documentDetection(imageData: imageDataArg) { result in
          switch result {
            case .success(let res):
              reply(wrapResult(res))
            case .failure(let error):
              reply(wrapError(error))
          }
        }
      }
    } else {
      documentDetectionChannel.setMessageHandler(nil)
    }
  }
}
