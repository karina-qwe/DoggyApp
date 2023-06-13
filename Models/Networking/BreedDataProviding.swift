//
//  BreedDataProviding.swift
//  Doggy
//
//  Created by Karyna Khotin on 21.05.2023.
//

import Foundation

protocol BreedDataProviding {
    func breedData(_ id: BreedId) async -> BreedData?
}
