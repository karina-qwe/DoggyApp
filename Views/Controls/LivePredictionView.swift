//
//  LivePredictionView.swift
//  Doggy
//
//  Created by Karyna Khotin on 17.05.2023.
//

import SwiftUI

struct LivePredictionView: View {
    @ObservedObject private(set) var model: LivePredictionViewModel
    
    var body: some View {
        VStack {
            Text(model.label ?? "🤷‍♂️🐶🤷‍♀️")
                .font(.body.bold())
//            Text(formatConfidence(model.confidence))
        }
        .onAppear{
            model.start()
        }
        .onDisappear {
            model.stop()
        }
    }
    
    private func formatConfidence(_ confidence: Double?) -> String {
        guard let confidence else { return "--" }
        return "\(confidence)"
    }
}

struct LivePredictionView_Previews: PreviewProvider {
    static var previews: some View {
        LivePredictionView(model: LivePredictionViewModel(
            liveImageClassifier: MockLiveImageClassifier()
        ))
    }
}
