//
//  BreedDataJsonParser.swift
//  Doggy
//
//  Created by Karyna Khotin on 21.05.2023.
//

import Foundation

class BreedDataJsonParser: BreedDataParsing {
    func parseBreedData(_ id: BreedId, data: Data) -> BreedData? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let rawData = try? decoder.decode(BreedDataRaw.self, from: data)
        return rawData.map { converRawData(id, rawData: $0)  }
    }
    
    private func converRawData(_ id: BreedId, rawData: BreedDataRaw) -> BreedData {
        BreedData(
            id: id,
            minLifeExpectancy: rawData.minLifeExpectancy,
            maxLifeExpectancy: rawData.maxLifeExpectancy,
            dimensionsMale: Dimensions(
                minHeight: inches(rawData.minHeightMale),
                maxHeight: inches(rawData.maxHeightMale),
                minWeight: pounds(rawData.minWeightMale),
                maxWeight: pounds(rawData.maxWeightMale)
            ),
            dimensionsFemale: Dimensions(
                minHeight: inches(rawData.minHeightFemale),
                maxHeight: inches(rawData.maxHeightFemale),
                minWeight: pounds(rawData.minWeightFemale),
                maxWeight: pounds(rawData.maxWeightFemale)
            ),
            shedding: cappedMetric(rawData.shedding),
            grooming: cappedMetric(rawData.grooming),
            drooling: cappedMetric(rawData.drooling),
            coatLength: cappedMetric(rawData.coatLength),
            playfulness: cappedMetric(rawData.playfulness),
            protectiveness: cappedMetric(rawData.protectiveness),
            trainability: cappedMetric(rawData.trainability),
            energy: cappedMetric(rawData.energy),
            barking: cappedMetric(rawData.barking),
            goodWithChildren: cappedMetric(rawData.goodWithChildren),
            goodWithOtherDogs: cappedMetric(rawData.goodWithOtherDogs),
            goodWithStrangers: cappedMetric(rawData.goodWithStrangers)
        )
    }
    
    // MARK: BreedDataRaw
    
    private struct BreedDataRaw: Decodable {
        var minLifeExpectancy: Int?
        var maxLifeExpectancy: Int?
        var maxHeightMale: Double?
        var maxHeightFemale: Double?
        var maxWeightMale: Double?
        var maxWeightFemale: Double?
        var minHeightMale: Double?
        var minHeightFemale: Double?
        var minWeightMale: Double?
        var minWeightFemale: Double?
        var shedding: Int?
        var grooming: Int?
        var drooling: Int?
        var coatLength: Int?
        var playfulness: Int?
        var protectiveness: Int?
        var trainability: Int?
        var energy: Int?
        var barking: Int?
        var goodWithChildren: Int?
        var goodWithOtherDogs: Int?
        var goodWithStrangers: Int?
    }
    
    // MARK: Converters
    
    private func inches(_ value: Double?) -> Measurement<UnitLength>? {
        value.map { Measurement(value: $0, unit: UnitLength.inches) }
    }
    
    private func pounds(_ value: Double?) -> Measurement<UnitMass>? {
        value.map { Measurement(value: $0, unit: UnitMass.pounds) }
    }
    
    private func cappedMetric(_ value: Int?) -> CappedMetric? {
        value.map { CappedMetric(low: 0, high: 5, value: $0) }
    }
}
