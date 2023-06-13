//
//  AppContext.swift
//  Doggy
//
//  Created by Karyna Khotin on 14.05.2023.
//

import SwiftUI

class AppContext: ObservableObject {
    let camera: Camera
    let imageClassifier: ImageClassifing
    let breedDataProvider: BreedDataProviding
        
    init(
        camera: Camera,
        imageClassifier: ImageClassifing,
        breedDataProvider: BreedDataProviding
    ) {
        self.camera = camera
        self.imageClassifier = imageClassifier
        self.breedDataProvider = breedDataProvider
    }
}
