//
//  functions.swift
//  myTestApp
//
//  Created by Michael Lichtenecker on 12.03.23.
//

import VisionKit
import Vision

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

func processImage(data: Data, orientation: CGImagePropertyOrientation) -> Array<String>? {
    let requestHandler = VNImageRequestHandler(data: data, orientation: orientation)

    // Create a new request to recognize text.
    let request = VNRecognizeTextRequest()

    do {
        // Perform the text-recognition request.
        try requestHandler.perform([request])
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return nil
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }
        return recognizedStrings
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
