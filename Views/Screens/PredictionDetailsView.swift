//
//  PredictionDetailsView.swift
//  Doggy
//
//  Created by Karyna Khotin on 20.05.2023.
//

import SwiftUI

struct PredictionDetailsView: View {
    @EnvironmentObject var context: AppContext
    
    let prediction: Prediction
    
    var body: some View {
        VStack(spacing: 0) {
//            Color(hex: 0xF5D7E6)
////                .overlay {
////                    header
////                }
            header
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                .background(Color(hex: 0xF5D7E6))
            breedDetail
            Spacer()
        }
//        .navigationBarTitle("", displayMode: .inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .frame(
            maxWidth: .infinity
        )
        .edgesIgnoringSafeArea([.bottom])
//        .background(Color(hex: 0xF5D7E6)) 
    }
    
    var header: some View {
        VStack {
            if let image = prediction.image.image {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 75)
                            .stroke(Color(hex: 0xF5D7E6), lineWidth: 5)
                    )
                    .shadow(color: .white, radius: 12, y: 4)
                
            }
            Text(prediction.identifier)
                .font(
                    .custom(
                        "Optima-ExtraBlack",
                        fixedSize: 32)
                    .weight(.black)
                )
                .foregroundColor(.accentColor)
            Text("\((prediction.confidence * 100).rounded(), specifier: "%.0f")%")
                .padding([.top], 0)
                .font(
                    .custom(
                        "Optima-ExtraBlack",
                        fixedSize: 20)
                    .weight(.black)
                )
                .foregroundColor(.accentColor)
        }
    }
    
    var breedDetail: some View {
        ViewModelBuilder(
            viewModelBuilder: { context in
                BreedDetailsViewModel(
                    context: context,
                    breedId: prediction.identifier
                )
            },
            viewBuilder: BreedDetailsView.init(model:)
        )
    }
}

struct DogDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PredictionDetailsView(
            prediction: Prediction(
                identifier: "dog-id",
                confidence: 0.42543,
                image: MockImages.beagle
            )
        )
        .environmentObject(AppContext.mock())
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Details View")
        
        NavigationStack {
            PredictionDetailsView(
                prediction: Prediction(
                    identifier: "dog-id",
                    confidence: 0.42543,
                    image: MockImages.beagle
                )
            )
        }
        .environmentObject(AppContext.mock())
        .previewDisplayName("Details Page")
    }
}
