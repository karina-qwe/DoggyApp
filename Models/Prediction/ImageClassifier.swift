//
//  ImageClassifier.swift
//  Doggy
//
//  Created by Karyna Khotin on 14.05.2023.
//

import Foundation
import Vision
import CoreImage

class ImageClassifier: ImageClassifing {
    private let model: VNCoreMLModel
    
    init(model: VNCoreMLModel? = nil) {
        self.model = model ?? ImageClassifier.createDefaultModel()
    }
    
    func classifyImage(_ ciImage: CIImage) async throws -> [Prediction] {
        let task = ClassificationTask(model: model, image: ciImage)
        return try await task.run()
    }
    
    // MARK: Classification Task
    
    private class ClassificationTask {
        let model: VNCoreMLModel
        let image: CIImage
        
        init(model: VNCoreMLModel, image: CIImage) {
            self.model = model
            self.image = image
        }
        
        func run() async throws -> [Prediction] {
            return try await withCheckedThrowingContinuation(run(continuation:))
        }
        
        private func run(continuation: CheckedContinuation<[Prediction], Error>) {
            let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                guard let self else {
                    continuation.resume(returning: [])
                    return
                }
                
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let predictions = self.parseResults(request.results)
                continuation.resume(returning: predictions)
                
            }
            request.imageCropAndScaleOption = .centerCrop
            
            let handler = VNImageRequestHandler(ciImage: image)
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
        
        private func parseResults(_ results: [VNObservation]?) -> [Prediction] {
            guard let observations = results as? [VNClassificationObservation] else {
                // Image classifiers, like MobileNet, only produce classification observations.
                // However, other Core ML model types can produce other observations.
                // For example, a style transfer model produces `VNPixelBufferObservation` instances.
                print("VNRequest produced the wrong result type: \(type(of: results)).")
                return []
            }
            
            let predictions = observations.map { observation in
                Prediction(
                    identifier: observation.identifier,
                    confidence: Double(observation.confidence),
                    image: image
                )
            }
            return predictions
        }
    }
    
    // MARK: Default Model
    
    private static func createDefaultModel() -> VNCoreMLModel {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        // Create an instance of the image classifier's wrapper class.
        let imageClassifierWrapper = try? DogBreedClassificationNet(configuration: defaultConfig)

        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }

        // Get the underlying model instance.
        let imageClassifierModel = imageClassifier.model

        // Create a Vision instance using the image classifier's model instance.
        var imageClassifierVisionModel: VNCoreMLModel! = nil
        do {
            imageClassifierVisionModel = try VNCoreMLModel(for: imageClassifierModel)
        } catch {
            print(error)
        }
//        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
//            fatalError("App failed to create a `VNCoreMLModel` instance.")
//        }

        return imageClassifierVisionModel
    }
}
