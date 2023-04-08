//
//  functions.swift
//  myTestApp
//
//  Created by Michael Lichtenecker on 12.03.23.
//

import VisionKit
import Vision
import Foundation

func recognizeTextHandler(request: VNRequest, error: Error?) {
    guard let observations =
            request.results as? [VNRecognizedTextObservation] else {
        return
    }
    let recognizedStrings = observations.compactMap { observation in
        // Return the string of the top VNRecognizedText instance.
        return observation.topCandidates(1).first?.string
    }

    // Process the recognized strings.
    print(recognizedStrings)
}
func convert(_ a: Double, maxDecimals max: Int) -> Double {
    let stringArr = String(a).split(separator: ".")
    let decimals = Array(stringArr[1])
    var string = "\(stringArr[0])."

    var count = 0;
    for n in decimals {
        if count == max { break }
        string += "\(n)"
        count += 1
    }


    let double = Double(string)!
    return double
}


func rowMatching(observations: [VNRecognizedTextObservation]) -> Array<Array<String>>{
    var rows: Array<Array<String>> = [];
    let counter = 0;
    
    var bufferOberervations = observations.map { $0 }
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    numberFormatter.usesSignificantDigits = false
    numberFormatter.roundingMode = .down
    numberFormatter.maximumFractionDigits = 6

    for observation in observations {
        var runRow: Array<String> = []
        let y = observation.boundingBox.minY;
        
        // If the right handside element is lower than the right one, then this will limit the down ward potential, which element can be counted for the current row.
        let overallOffest = 0.011900
        // If the right handside element is slightly higher than the left one, this will limit the height for a given "row"
        let biggerOffset = -0.0005
        
        
        let neOffset = observation.boundingBox.minY - overallOffest;
        
        var deleteIndex: Array<Int> = [];
        var counter = 0;
        for x in bufferOberervations {
            
            if convert(x.boundingBox.minY, maxDecimals: 6) == convert(y, maxDecimals: 6) ||
                x.boundingBox.minY >= neOffset && x.boundingBox.minY <= y || y - x.boundingBox.minY  <=  biggerOffset {
                
                runRow.append(x.topCandidates(1).first!.string)
                deleteIndex.append(counter)
            }
            counter+=1;
        }
        if (deleteIndex.count != 0){
            for index in deleteIndex.reversed() {
                bufferOberervations.remove(at: index)
            }
            
        }
        rows.append(runRow)
    }
    return rows

}

func experiment(data: [VNRecognizedTextObservation]){
    var runRow: Array<String> = []
    for obs in data{
        var currentItem: String = obs.topCandidates(1).first!.string
        for y in data{
            if (convert(obs.boundingBox.minY, maxDecimals: 7) < convert(obs.boundingBox.minY, maxDecimals: 7)){
                currentItem = y.topCandidates(1).first!.string
            }
        }
        runRow.append(currentItem)
    }
    print("iuzfsbdizfubsdufz")
    print(runRow)
}

func processImage(data: Data, orientation: CGImagePropertyOrientation) -> [String: Any]? {
    let requestHandler = VNImageRequestHandler(data: data, orientation: orientation)

    // Create a new request to recognize text.
    let request = VNRecognizeTextRequest()
    request.recognitionLevel = .accurate
    

    do {
        // Perform the text-recognition request.
        try requestHandler.perform([request])
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return nil
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            print(observation)
            print(observation.topCandidates(1).first?.string)
            
            return observation.topCandidates(1).first?.string
        }
        let analyze_result = rowMatching(observations: observations)

        print(experiment(data: observations))
        
        let jsonData = try! JSONSerialization.data(withJSONObject: analyze_result)
        
        return [ "analyze": String(data: jsonData, encoding: .utf8)!, "raw": recognizedStrings]
    } catch {
        print("Unable to perform the requests: \(error).")
        return nil
    }
}

func matchOrientationString(str: String) -> CGImagePropertyOrientation {
    switch str {
    case "up":
        return CGImagePropertyOrientation.up
    case "down":
        return CGImagePropertyOrientation.down
    case "left":
        return CGImagePropertyOrientation.left
    case "right":
        return CGImagePropertyOrientation.right
    default:
        return CGImagePropertyOrientation.up
    }
    
}
