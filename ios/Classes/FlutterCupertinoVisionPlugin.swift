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
          
          //let data = Data(referencing:NSData(bytes: pdata!, length: pdata!.count))
          let orientationV = matchOrientationString(str: orientation!)
            
            
        let res = processImage(data: Data(pdata!.data), orientation: orientationV)
        
        result(res)
        break;
      default:
        result("abc")
    }
  }
}
