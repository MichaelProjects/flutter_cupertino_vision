import Flutter
import UIKit

public class FlutterCupertinoVisionPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_cupertino_vision", binaryMessenger: registrar.messenger())
    let instance = FlutterCupertinoVisionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "imageToText":
          var pdata: FlutterStandardTypedData?;
          var orientation: String?;
          let args = call.arguments as? [String: Any]
        
          pdata = args?["imageData"] as? FlutterStandardTypedData;
          orientation = args?["orientation"]! as? String
          
          let orientationV = matchOrientationString(str: orientation!)
            
            
        let res = processImage(data: Data(pdata!.data), orientation: orientationV)
        
        result(res)
        break;
      case "extractTextboxesFromImage":
        var pdata: FlutterStandardTypedData?;
        var orientation: String?;
        
        let args = call.arguments as? [String: Any]
        pdata = args?["imageData"] as? FlutterStandardTypedData;
        orientation = args?["orientation"]! as? String
        
        let orientationV = matchOrientationString(str: orientation!)
        
        let res = extractText(data: Data(pdata!.data), orientation: orientationV)
        let obervations: [[String: Any]] = prepareResultData(data: res!)
        
        result(obervations)
        
      default:
        result("abc")
    }
  }
}
