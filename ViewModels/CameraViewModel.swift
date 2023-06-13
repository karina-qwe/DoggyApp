//
//  CameraViewModel.swift
//  Doggy
//
//  Created by Karyna Khotin on 14.05.2023.
//

import SwiftUI

@MainActor
final class CameraViewModel: ObservableObject {
    private let camera: Camera
    
    @Published var viewfinderImage: Image?
    
    init(camera: Camera) {
        self.camera = camera
        
        Task { [weak self] in
            await self?.camera.run()
            await self?.processLiveStream()
        }
    }
    
    deinit {
        camera.stop()
    }
    
    func suspend() {
        camera.suspend()
    }
    
    func resume() {
        camera.resume()
    }
    
    func toggleRunning() {
        if camera.isRunning {
            suspend()
        } else {
            resume()
        }
    }
    
    private func processLiveStream() async {
        for await liveImage in camera.liveStream.values {
            Task { @MainActor in
                viewfinderImage = liveImage.image
            }
        }
    }
}
