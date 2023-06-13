//
//  LiveImageClassifier.swift
//  Doggy
//
//  Created by Karyna Khotin on 17.05.2023.
//

import Foundation
import CoreImage
import UIKit
import Combine

actor LiveImageClassifier: LiveImageClassifing {
    private let imageClassifier: ImageClassifing
    private let imageStream: AnyPublisher<CIImage, Never>
    private let throttleInterval: Double
    
    private var runningTask: Task<Void, Error>?
    private var predictionLoopTask: Task<Void, Error>?
    
    private var pendingImage: CIImage?
    private var lastPredictionTime: TimeInterval?
    private let preditionsSubject = PassthroughSubject<[Prediction], Never>()
    
    init(
        imageClassifier: ImageClassifing,
        imageStream: AnyPublisher<CIImage, Never>,
        throttleInterval: Double = 0.3
    ) {
        self.imageClassifier = imageClassifier
        self.imageStream = imageStream
        self.throttleInterval = throttleInterval
        self.predictionsStream = preditionsSubject.eraseToAnyPublisher()
    }
    
    // MARK: LiveImageClassifing
    
    func run() {
        guard runningTask == nil else { return }
        runningTask = Task {
            await observeImageStream()
        }
    }
    
    func stop() {
        runningTask?.cancel()
        runningTask = nil
        predictionLoopTask?.cancel()
        predictionLoopTask = nil
        pendingImage = nil
        lastPredictionTime = nil
    }
    
    let predictionsStream: AnyPublisher<[Prediction], Never>
    
    // MARK: Private
    
    private func observeImageStream() async {
        for await image in imageStream.values {
            imageChanged(image)
        }
    }
    
    private func imageChanged(_ image: CIImage) {
        pendingImage = image
        schedulePredictionIfNeeded()
    }
    
    private func schedulePredictionIfNeeded() {
        guard predictionLoopTask == nil else { return }
        guard pendingImage != nil else { return }
        
        predictionLoopTask = Task {
            var delay: TimeInterval = 0.0
            if let lastPredictionTime {
                let timeSinceLastPrediction = CACurrentMediaTime() - lastPredictionTime
                delay = throttleInterval - timeSinceLastPrediction
            }
            if (delay > 0.0) {
                try? await Task.sleep(for: .seconds(delay))
                guard !Task.isCancelled else { return }
            }
            
            if let predictions = await predictPendingImageIfNeeded() {
                lastPredictionTime = CACurrentMediaTime()
                preditionsSubject.send(predictions)
            }
            
            predictionLoopTask = nil
            guard !Task.isCancelled else { return }
            schedulePredictionIfNeeded()
        }
    }
    
    private func predictPendingImageIfNeeded() async -> [Prediction]? {
        guard let pendingImage else { return nil }
        self.pendingImage = nil
        return await predictImage(pendingImage)
    }
    
    private func predictImage(_ image: CIImage) async -> [Prediction] {
        let predictions: [Prediction]
        do {
            predictions = try await imageClassifier.classifyImage(image)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
            predictions = []
        }
        return predictions
    }
}
