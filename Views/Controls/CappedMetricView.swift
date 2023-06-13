//
//  CappedMetricView.swift
//  Doggy
//
//  Created by Karyna Khotin on 21.05.2023.
//

import SwiftUI

struct CappedMetricView: View {
    private let stepsCount: UInt
    private let tintColor: Color
    private let progress: UInt
    
    init(
        metric: CappedMetric,
        stepsCount: UInt = 5,
        tintColor: Color = .green
    ) {
        self.stepsCount = stepsCount
        self.tintColor = tintColor
        
        let rangeSize = Double(metric.high - metric.low)
        let normalizedValue = Double(metric.value - metric.low)
        let progressFraction = normalizedValue / rangeSize
        progress = UInt((progressFraction * Double(stepsCount)).rounded(.awayFromZero))
    }
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(
                1...stepsCount,
                id: \.self
            ) {
                buildStep($0)
            }
        }
        .clipShape(Capsule())
        .frame(height: 20)
        .overlay {
            Capsule()
                .stroke(.green, lineWidth: 1)
                .opacity(0.5)
        }
    }
    
    private func buildStep(_ step: UInt) -> some View {
        Rectangle()
            .fill(step <= progress ? .green : .clear)
            .opacity(1.0 / Double(stepsCount) * Double(step))
    }
}

struct CappedMetricView_Previews: PreviewProvider {
    static var previews: some View {
        CappedMetricView(
            metric: CappedMetric(low: 0, high: 30, value: 20)
        )
        .previewLayout(.fixed(width: 300, height: 50))
    }
}
