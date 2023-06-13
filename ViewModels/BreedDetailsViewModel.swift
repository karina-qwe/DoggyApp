//
//  BreedDetailsViewModel.swift
//  Doggy
//
//  Created by Karyna Khotin on 21.05.2023.
//

import SwiftUI

@MainActor
final class BreedDetailsViewModel: ObservableObject {
    private let breedId: BreedId
    private let breedDataProvider: BreedDataProviding
    
    @Published private(set) var breedData: BreedData
    @Published private(set) var status: FetchStatus = .pending
    
    init(breedId: BreedId, breedDataProvider: BreedDataProviding) {
        self.breedId = breedId
        self.breedDataProvider = breedDataProvider
        self.breedData = BreedData(id: breedId)
    }
    
    convenience init(context: AppContext, breedId: BreedId) {
        self.init(breedId: breedId, breedDataProvider: context.breedDataProvider)
    }
    
    func loadBreedData() async {
        guard let data = await breedDataProvider.breedData(breedId) else {
            status = .failed
            return
        }
        breedData = data
        status = .fetched
    }
}

