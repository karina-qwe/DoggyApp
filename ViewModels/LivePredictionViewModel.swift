//
//  LivePredictionViewModel.swift
//  Doggy
//
//  Created by Karyna Khotin on 13.05.2023.
//

import SwiftUI
import Combine

@MainActor
final class LivePredictionViewModel: ObservableObject {
    private let liveImageClassifier: LiveImageClassifing
    private let confidenceThreshold: Double
    private var predictionsTask: Task<Void, Never>?
    
    @Published var prediction: Prediction?
    
    init(liveImageClassifier: LiveImageClassifing, confidenceThreshold: Double = 0.6) {
        self.liveImageClassifier = liveImageClassifier
        self.confidenceThreshold = confidenceThreshold
    }
    
    deinit {
        predictionsTask?.cancel()
    }
    
    convenience init(imageClassifier: ImageClassifing, imageStream: AnyPublisher<CIImage, Never>) {
        self.init(
            liveImageClassifier: LiveImageClassifier(
                imageClassifier: imageClassifier,
                imageStream: imageStream
            )
        )
    }
    
    convenience init(context: AppContext) {
        self.init(
            imageClassifier: context.imageClassifier,
            imageStream: context.camera.liveStream
        )
    }
    
    func start() {
        predictionsTask = Task {
            await liveImageClassifier.run()
            await observePredictions()
        }
    }
    
    func stop() {
        predictionsTask?.cancel()
        Task {
            await liveImageClassifier.stop()
        }
    }
    
    var label: String? {
        prediction?.identifier
    }
    
    var confidence: Double? {
        prediction?.confidence
    }
    
    nonisolated private func observePredictions() async {
        for await predictions in liveImageClassifier.predictionsStream.values {
            await updatePredictions(predictions)
        }
    }
    
    private func updatePredictions(_ predictions: [Prediction]) {
        guard let prediction = predictions.first, prediction.confidence >= confidenceThreshold else {
            self.prediction = nil
            return
        }
        self.prediction = prediction
    }
}
