//
//  BreedDataParsing.swift
//  Doggy
//
//  Created by Karyna Khotin on 21.05.2023.
//

import Foundation

protocol BreedDataParsing {
    func parseBreedData(_ id: BreedId, data: Data) -> BreedData?
}
