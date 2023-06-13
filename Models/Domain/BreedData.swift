//
//  BreedData.swift
//  Doggy
//
//  Created by Karyna Khotin on 21.05.2023.
//

import Foundation

struct BreedData {
    var id: BreedId
    var minLifeExpectancy: Int?
    var maxLifeExpectancy: Int?
    var dimensionsMale: Dimensions?
    var dimensionsFemale: Dimensions?
    var shedding: CappedMetric?
    var grooming: CappedMetric?
    var drooling: CappedMetric?
    var coatLength: CappedMetric?
    var playfulness: CappedMetric?
    var protectiveness: CappedMetric?
    var trainability: CappedMetric?
    var energy: CappedMetric?
    var barking: CappedMetric?
    var goodWithChildren: CappedMetric?
    var goodWithOtherDogs: CappedMetric?
    var goodWithStrangers: CappedMetric?
}

struct Dimensions {
    // Height in centimeters
    var minHeight: Measurement<UnitLength>?
    var maxHeight: Measurement<UnitLength>?
    
    // Weight in kilograms
    var minWeight: Measurement<UnitMass>?
    var maxWeight: Measurement<UnitMass>?
}

struct CappedMetric {
    var low: Int
    var high: Int
    var value: Int
}
