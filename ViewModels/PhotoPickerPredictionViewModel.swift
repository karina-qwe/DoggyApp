//
//  PhotoPickerPredictionViewModel.swift
//  Doggy
//
//  Created by Karyna Khotin on 27.05.2023.
//

import SwiftUI
import PhotosUI
import CoreImage

@MainActor
final class PhotoPickerPredictionViewModel: ObservableObject {
    private let imageClassifier: ImageClassifing
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            runClassifincationIfNeeded()
        }
    }
    
    @Published private(set) var prediction: Prediction? = nil
    
    init(imageClassifier: ImageClassifing) {
        self.imageClassifier = imageClassifier
    }
    
    convenience init(context: AppContext) {
        self.init(imageClassifier: context.imageClassifier)
    }
    
    private func runClassifincationIfNeeded() {
        guard let imageSelection else {
            prediction = nil
            return
        }
        Task {
            guard let image = await loadImage(pickerItem: imageSelection) else {
                prediction = nil
                return
            }
            prediction = await classifyImage(image)
        }
    }
    
    private nonisolated func classifyImage(_ ciImage: CIImage) async -> Prediction? {
        try? await imageClassifier.classifyImage(ciImage).first
    }
    
    private nonisolated func loadImage(pickerItem: PhotosPickerItem) async -> CIImage? {
        guard let data = try? await pickerItem.loadTransferable(type: Data.self) else {
            return nil
        }
        
        guard
            let uiImage = UIImage(data: data),
            let ciImage = CIImage(image: uiImage)
        else {
            return nil
        }
        
        return ciImage.oriented(.init(uiImage.imageOrientation))
    }
}
