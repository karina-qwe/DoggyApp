//
//  BreedDataFetcher.swift
//  Doggy
//
//  Created by Karyna Khotin on 21.05.2023.
//

import Foundation
import os.log

private let logger = os.Logger(subsystem: "pro.iking.Doggy", category: "BreedDataFetcher")

class BreedDataFetcher: BreedDataProviding {
    private enum Config {
        static let scheme = "https"
        static let host = "puppy.iking.pro"
        
        enum Path {
            static let data = "/api/v1/breed-data"
        }
        
        enum Query {
            static let id = "breed-id"
        }
    }
    
    private let urlSession: URLSession
    private let parser = BreedDataJsonParser()
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func breedData(_ id: BreedId) async -> BreedData? {
        let data = await fetchBreedData(id)
        return data.flatMap {
            parser.parseBreedData(id, data: $0)
        }
    }
    
    private func fetchBreedData(_ id: BreedId) async -> Data? {
        guard let url = buildDataUrl(id) else {
            logger.error("Failed to construct data fetch url for breed id: \(id).")
            return nil
        }
        do {
            let (data, response) = try await urlSession.data(from: url)
            guard isSuccessfulResponse(response) else {
                logger.warning("Failed to fetch data for breed id: \(id), response: \(response).")
                return nil
            }
            return data
        } catch {
            logger.warning("Failed to fetch data for breed id: \(id), error: \(error).")
            return nil
        }
    }
    
    // MARK: URL Building
    
    private func buildDataUrl(_ id: BreedId) -> URL? {
        var components = baseUrlCombonents()
        components.path = Config.Path.data
        components.queryItems = [
            idQueryItem(id)
        ]
        return components.url
    }
    
    private func baseUrlCombonents() -> URLComponents {
        var components = URLComponents()
        components.scheme = Config.scheme
        components.host = Config.host
        return components
    }
    
    private func idQueryItem(_ id: BreedId) -> URLQueryItem {
        URLQueryItem(name: Config.Query.id, value: id)
    }
    
    // MARK: Response Validation
    
    private func isSuccessfulResponse(_ response: URLResponse) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse else {
            return false
        }
        return (200..<300).contains(httpResponse.statusCode)
    }
}
