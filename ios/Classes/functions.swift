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
    //print(recognizedStrings)
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


/// This objects should represent a minimal version of [VNRecognizedTextObservation] and it contains all needed data to work with to determine where the given text is located on the image it was extracted from.
struct DataPoint {
    let x: Double
    let y: Double
    let height: Double
    let width: Double
    let candidates: [String]
    
    init(x: Double, y: Double, height: Double, width: Double, candidates: [String]) {
        self.x = x
        self.y = y
        self.height = height
        self.width = width
        self.candidates = candidates
    }
}
func dataPointToDictionary(dataPoint: DataPoint) -> [String: Any] {
    return [
        "x": dataPoint.x,
        "y": dataPoint.y,
        "height": dataPoint.height,
        "width": dataPoint.width,
        "candidates": dataPoint.candidates
    ]
}


func prepareResultData(data: [VNRecognizedTextObservation]) -> [[String: Any]]{
    var dataPoints: [[String: Any]] = [];
    
    for observation in data{
        let observationMap: [String: Any] = [
            "boundingBox": [
                "left": observation.boundingBox.minX,
                "top": observation.boundingBox.minY,
                "width": observation.boundingBox.width,
                "height": observation.boundingBox.height,
            ],
            "confidence": observation.confidence,
            "candidates": observation.topCandidates(3).map({ $0.string }),
        ]
        dataPoints.append(observationMap);
    }
    return dataPoints
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
    //print(runRow)
}


/// Gets image data with the according orientation and uses the Apple VisonAPI to extract the text contained in the image.
func extractText(data: CGImage, orientation: CGImagePropertyOrientation) -> [VNRecognizedTextObservation]? {
    let requestHandler = VNImageRequestHandler(cgImage: data, orientation: orientation)
    
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
        return observations

    } catch {
        print("Unable to perform the requests: \(error).")
        return nil
    }
}


func processImage(data: CGImage, orientation: CGImagePropertyOrientation) -> [String: Any]? {
    var observations = extractText(data: data, orientation: orientation);
        let recognizedStrings = observations!.compactMap { observation in
            
            return observation.topCandidates(1).first?.string
        }
        let analyze_result = rowMatching(observations: observations!)

        //print(experiment(data: observations!))
        
        let jsonData = try! JSONSerialization.data(withJSONObject: analyze_result)
        
        return [ "analyze": String(data: jsonData, encoding: .utf8)!, "raw": recognizedStrings]
}

func extractTextFromImage(data: Data, orientation: CGImagePropertyOrientation) -> [VisionResponse] {
    let handler = VNImageRequestHandler(data: data, orientation: orientation, options: [:])
    let request = VNRecognizeTextRequest(completionHandler: nil)
    
    do {
        try handler.perform([request])
        guard let observations = request.results as? [VNRecognizedTextObservation] else { return [] }
        
        return observations.compactMap { observation in
            guard let topCandidate = observation.topCandidates(1).first else { return nil }
            
            let boundingBox = observation.boundingBox
            let transformedRect = transformBoundingBox(boundingBox)
            
            let visionResponse = VisionResponse(
                boundingBox: BoundingBox(
                    left: Double(transformedRect.origin.x),
                    top: Double(transformedRect.origin.y),
                    width: Double(transformedRect.width),
                    height: Double(transformedRect.height)
                ),
                confidence: Double(topCandidate.confidence), candiates: [topCandidate.string]
            )
            
            return visionResponse
        }
    } catch {
        print("Error in text recognition: \(error)")
        return []
    }
}

func transformBoundingBox(_ rect: CGRect) -> CGRect {
    // Transform the rect from VNImageCoordinateSystem to your view's coordinate system.
    // The transformation depends on how you're displaying the image.
    // This is a placeholder function. You'll need to implement the actual transformation.
    return rect
}

public func documentDetectionFunction(data: CGImage, orientation: CGImagePropertyOrientation) -> [VNRectangleObservation]? {
    let requestHandler = VNImageRequestHandler(cgImage: data, orientation: orientation)
    
    if #available(iOS 15.0, *) {
        let request = VNDetectDocumentSegmentationRequest()
        do {
            try requestHandler.perform([request])
            guard let observations =
                    request.results as? [VNRectangleObservation] else {
                return nil
            }
            return observations

        } catch {
            print("Unable to perform the requests: \(error).")
            return nil
        }
    } else {
        
    }
    return nil
    
}





public func documentDetectionNewFunction(data: Data, orientation: CGImagePropertyOrientation) -> [VisionResponse]? {
    let requestHandler = VNImageRequestHandler(data: data, orientation: orientation)

    if #available(iOS 15.0, *) {
        let request = VNDetectDocumentSegmentationRequest()
        do {
            try requestHandler.perform([request])
            guard let observations = request.results as? [VNRectangleObservation] else {
                return nil
            }

            return observations.map { observation in
                let boundingBox = BoundingBox(
                    left: Double(observation.boundingBox.origin.x),
                    top: Double(observation.boundingBox.origin.y),
                    width: Double(observation.boundingBox.size.width),
                    height: Double(observation.boundingBox.size.height)
                )
                let confidence = Double(observation.confidence)
                return VisionResponse(boundingBox: boundingBox, confidence: confidence, candiates: [])
            }

        } catch {
            print("Unable to perform the requests: \(error).")
            return nil
        }
    } else {
        // Handle older iOS versions or return a default value
        return nil
    }
}


extension ImageOrientation {
    func toCGImagePropertyOrientation() -> CGImagePropertyOrientation {
        switch self {
        case .up:
            return .up
        case .down:
            return .down
        case .left:
            return .left
        case .right:
            return .right
        }
    }
}
