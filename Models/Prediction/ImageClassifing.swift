//
//  ImageClassifing.swift
//  Doggy
//
//  Created by Karyna Khotin on 14.05.2023.
//

import Foundation
import CoreImage

protocol ImageClassifing {
    func classifyImage(_ ciImage: CIImage) async throws -> [Prediction]
}
