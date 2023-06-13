//
//  Prediction.swift
//  Doggy
//
//  Created by Karyna Khotin on 21.05.2023.
//

import Foundation
import CoreImage

struct Prediction: Hashable {
    var identifier: BreedId
    var confidence: Double
    var image: CIImage
}
