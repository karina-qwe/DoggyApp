//
//  BreedDetailsView.swift
//  Doggy
//
//  Created by Karyna Khotin on 21.05.2023.
//

import SwiftUI

struct BreedDetailsView: View {
    @ObservedObject private(set) var model: BreedDetailsViewModel
    
    var body: some View {
        VStack {
            switch model.status {
            case .fetched:
                loadedBody
            case .pending:
                loadingBody
            case .failed:
                failedBody
            }
        }
        .background(Color(hex: 0x071863).opacity(0.3))
        .task {
            await model.loadBreedData()
        }
    }
    
    var loadingBody: some View {
        VStack(spacing: 4) {
            Spacer()
            ProgressView()
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    var failedBody: some View {
        VStack(spacing: 4) {
            Spacer()
            Text("Error occured")
                .font(.headline)
                .foregroundColor(.white)
            Text("No breed details to view.")
                .font(.caption)
                .foregroundColor(.white)
            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    var loadedBody: some View {
        let cells = buildCellContent()
        return List {
            BreedDetailsCell(
                label: "lifespan",
                icon: Image("lifespan")) {
                    lifespanCellContent
                }
            .listRowInsets(EdgeInsets())
            .alignmentGuide(.listRowSeparatorLeading) { d in
                d[.leading]
            }
            
            HStack {
                BreedDetailsCell(
                    label: "weight",
                    icon: Image("weight")) {
                        weightCellContent
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                BreedDetailsCell(
                    label: "height",
                    icon: Image("height")) {
                        heightCellContent
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .listRowInsets(EdgeInsets())
            .alignmentGuide(.listRowSeparatorLeading) { d in
                d[.leading]
            }

            ForEach(0..<cells.count, id: \.self) { i in
                cells[i]
                    .listRowInsets(EdgeInsets())
            }
            .alignmentGuide(.listRowSeparatorLeading) { d in
                d[.leading]
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    func intSpan(min: Int?, max: Int?, unit: String? = nil) -> some View {
        Text(
            formatOptionalInt(min) + "-" +
            formatOptionalInt(max) +
            (unit.map { " \($0)" } ?? "")
        )
    }
    
    var lifespanCellContent: some View {
        return intSpan(
            min: model.breedData.minLifeExpectancy,
            max: model.breedData.maxLifeExpectancy,
            unit: String(localized: "unit-years")
        )
    }
    
    var weightCellContent: some View {
        let minWeight = minWeight(model.breedData)?
            .converted(to: .kilograms).value
        let maxWeight = maxWeight(model.breedData)?
            .converted(to: .kilograms).value
        
        return intSpan(
            min: minWeight.map(Int.init),
            max: maxWeight.map(Int.init),
            unit: String(localized: "unit-kg")
        )
    }
    
    func minWeight(_ breedData: BreedData) -> Measurement<UnitMass>? {
        let male = breedData.dimensionsMale?.minWeight
        let felame = breedData.dimensionsFemale?.minWeight
        if let male, let felame{
            return min(male, felame)
        }
        return male ?? felame
    }
    
    func maxWeight(_ breedData: BreedData) -> Measurement<UnitMass>? {
        let male = breedData.dimensionsMale?.maxWeight
        let felame = breedData.dimensionsFemale?.maxWeight
        if let male, let felame {
            return max(male, felame)
        }
        return male ?? felame
    }
    
    var heightCellContent: some View {
        let minHeight = minHeight(model.breedData)?
            .converted(to: .centimeters).value
        let maxWeight = maxHeight(model.breedData)?
            .converted(to: .centimeters).value
        
        return intSpan(
            min: minHeight.map(Int.init),
            max: maxWeight.map(Int.init),
            unit: String(localized: "unit-cm")
        )
    }
    
    func minHeight(_ breedData: BreedData) -> Measurement<UnitLength>? {
        let male = breedData.dimensionsMale?.minHeight
        let felame = breedData.dimensionsFemale?.minHeight
        if let male, let felame{
            return min(male, felame)
        }
        return male ?? felame
    }
    
    func maxHeight(_ breedData: BreedData) -> Measurement<UnitLength>? {
        let male = breedData.dimensionsMale?.maxHeight
        let felame = breedData.dimensionsFemale?.maxHeight
        if let male, let felame {
            return max(male, felame)
        }
        return male ?? felame
    }
    
    func formatOptionalInt(_ value: Int?) -> String {
        if let value {
            return "\(value)"
        }
        return "🤷‍♂️"
    }
    
    private func buildCellContent() -> [BreedDetailsCell<CappedMetricView>] {
        var cells = [BreedDetailsCell<CappedMetricView>]()
        
        if let grooming = model.breedData.grooming {
            cells.append(BreedDetailsCell(
                label: "grooming",
                icon: Image("grooming"),
                iconSize: CGSize(width: 30, height: 40)) {
                    CappedMetricView(metric: grooming)
                })
        }
        
        if let barking = model.breedData.barking {
            cells.append(BreedDetailsCell(
                label: "barking",
                icon: Image("barking")) {
                    CappedMetricView(metric: barking)
                })
        }

        if let playfulness = model.breedData.playfulness {
            cells.append(BreedDetailsCell(
                label: "playfulness",
                icon: Image("playfulness"),
                iconSize: CGSize(width: 30, height: 40)) {
                    CappedMetricView(metric: playfulness)
                })
        }

        if let drooling = model.breedData.drooling {
            cells.append(BreedDetailsCell(
                label: "drooling",
                icon: Image("drooling")) {
                    CappedMetricView(metric: drooling)
                })
        }
        
        if let shedding = model.breedData.shedding {
            cells.append(BreedDetailsCell(
                label: "shedding",
                icon: Image("shedding")) {
                    CappedMetricView(metric: shedding)
                })
        }

        if let coatLength = model.breedData.coatLength {
            cells.append(BreedDetailsCell(
                label: "coatLength",
                icon: Image("coatLength")) {
                    CappedMetricView(metric: coatLength)
                })
        }

        if let protectiveness = model.breedData.protectiveness {
            cells.append(BreedDetailsCell(
                label: "protectiveness",
                icon: Image("protectiveness")) {
                    CappedMetricView(metric: protectiveness)
                })
        }

        if let trainability = model.breedData.trainability {
            cells.append(BreedDetailsCell(
                label: "trainability",
                icon: Image("trainability")) {
                    CappedMetricView(metric: trainability)
                })
        }

        if let energy = model.breedData.energy {
            cells.append(BreedDetailsCell(
                label: "energy",
                icon: Image("energy")) {
                    CappedMetricView(metric: energy)
                })
        }

        if let goodWithChildren = model.breedData.goodWithChildren {
            cells.append(BreedDetailsCell(
                label: "goodWithChildren",
                icon: Image("friendship")) {
                    CappedMetricView(metric: goodWithChildren)
                })
        }

        if let goodWithOtherDogs = model.breedData.goodWithOtherDogs {
            cells.append(BreedDetailsCell(
                label: "goodWithOtherDogs",
                icon: Image("friendship")) {
                    CappedMetricView(metric: goodWithOtherDogs)
                })
        }

        if let goodWithStrangers = model.breedData.goodWithStrangers {
            cells.append(BreedDetailsCell(
                label: "goodWithStrangers",
                icon: Image("friendship")) {
                    CappedMetricView(metric: goodWithStrangers)
                })
        }

        return cells
    }
}

struct BreedDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BreedDetailsView(
            model: BreedDetailsViewModel(
                breedId: "dog-id",
                breedDataProvider: MockBreedDataProvider(
                    data: BreedData(
                        id: "dog-id",
                        minLifeExpectancy: 5,
                        maxLifeExpectancy: 10,
                        shedding: CappedMetric(low: 0, high: 5, value: 2),
                        grooming: CappedMetric(low: 0, high: 5, value: 4)
                    )
                )
            )
        )
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Loaded")
        
        BreedDetailsView(
            model: BreedDetailsViewModel(
                breedId: "dog-id",
                breedDataProvider: MockBreedDataProvider(data: nil)
            )
        )
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Failed")
    }
}
