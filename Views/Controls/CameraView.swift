//
//  CameraView.swift
//  Doggy
//
//  Created by Karyna Khotin on 14.05.2023.
//

import SwiftUI

struct CameraView: View {
    @ObservedObject private(set) var model: CameraViewModel
    
    var body: some View {
        ViewfinderView(image: $model.viewfinderImage)
            .onAppear {
                model.resume()
            }
            .onDisappear {
                model.suspend()
            }
            .onTapGesture {
                model.toggleRunning()
            }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(model: CameraViewModel(camera: MockCamera()))
    }
}
