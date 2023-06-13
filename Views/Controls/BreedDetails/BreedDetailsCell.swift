//
//  BreedDetailsCell.swift
//  Doggy
//
//  Created by Karyna Khotin on 21.05.2023.
//

import SwiftUI

struct BreedDetailsCell<Body: View>: View {
    let label: LocalizedStringKey
    let icon: Image?
    let iconSize: CGSize
    let content: () -> Body
    
    init(
        label: LocalizedStringKey,
        icon: Image?,
        iconSize: CGSize = CGSize(width: 30, height: 30),
        content: @escaping () -> Body
    ) {
        self.label = label
        self.icon = icon
        self.iconSize = iconSize
        self.content = content
    }
    
    var body: some View {
        HStack {
            if let icon {
                icon
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: iconSize.width, height: iconSize.height)
                    .foregroundColor(.black.opacity(0.7))

            }
            VStack(alignment: .leading) {
                Text(label)
                    .lineLimit(1)
                content()
            }
        }.padding(16)
    }
}

struct BreedDetailsCell_Previews: PreviewProvider {
    static var previews: some View {
        BreedDetailsCell(
            label: "Grooming",
            icon: Image(systemName: "globe")) {
                CappedMetricView(metric: CappedMetric(low: 0, high: 5, value: 4))
            }
            .previewLayout(.sizeThatFits)
    }
}
