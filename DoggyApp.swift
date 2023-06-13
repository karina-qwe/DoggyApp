//
//  DoggyApp.swift
//  Doggy
//
//  Created by Karyna Khotin on 12.05.2023.
//

import SwiftUI

@main
struct DoggyApp: App {
    @StateObject var context: AppContext = AppContext(
        camera: CameraDevice(),
        imageClassifier: ImageClassifier(),
        breedDataProvider: BreedDataFetcher(urlSession: .shared)
    )
    
    init() {
        UINavigationBar.applyCustomAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(context)
                .tint(Color(hex: 0x071863))
        }
    }
}

fileprivate extension UINavigationBar {
    
    static func applyCustomAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
