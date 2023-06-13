//
//  Camera.swift
//  Doggy
//
//  Created by Karyna Khotin on 14.05.2023.
//

import Combine
import CoreImage

protocol CameraStreamProvider {
    var liveStream: AnyPublisher<CIImage, Never> { get }
}

protocol CameraController {
    func run() async
    func stop()
    func suspend()
    func resume()
    var isRunning: Bool { get }
}

protocol Camera: CameraController, CameraStreamProvider { }
