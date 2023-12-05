import Flutter
import UIKit

enum ImageError: Error {
    case parsingFailed
}

public class FlutterCupertinoVisionPlugin: NSObject, ImageProcessingApi, FlutterPlugin {
    func imageToText(imageData: InputImageData, completion: @escaping (Result<[VisionResponse], Error>) -> Void) {
        
        let res = extractTextFromImage(data: imageData.data.data, orientation: imageData.orientation.toCGImagePropertyOrientation())
    
        completion(.success(res))
    }

    func documentDetection(imageData: InputImageData, completion: @escaping (Result<[VisionResponse], Error>) -> Void) {
        // Implement your logic for document detection
        // Return the result or error via the completion handler
        let res = documentDetectionNewFunction(data: imageData.data.data, orientation: imageData.orientation.toCGImagePropertyOrientation())
        if let res = res {
            // If 'res' is not nil, return it as a success result
            completion(.success(res))
        } else {
            // If 'res' is nil, return an empty array as a success result
            completion(.success([]))
        }
    }
    
  public static func register(with registrar: FlutterPluginRegistrar
  ) {
  let messenger : FlutterBinaryMessenger = registrar.messenger()
      let api: ImageProcessingApi = FlutterCupertinoVisionPlugin.init();
      ImageProcessingApiSetup.setUp(binaryMessenger: messenger, api: api)
  }
}
