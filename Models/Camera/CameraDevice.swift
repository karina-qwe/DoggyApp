//
//  CameraDevice.swift
//  Doggy
//
//  Created by Karyna Khotin on 19.05.2023.
//

import AVFoundation
import CoreImage
import os.log
import Combine

fileprivate let logger = Logger(subsystem: "com.apple.swiftplaygroundscontent.capturingphotos", category: "Camera")

// TODO: Make CameraDevice an actor

class CameraDevice: NSObject, Camera {
    private let captureSession = AVCaptureSession()
    private var isCaptureSessionConfigured: Bool = false
    private var deviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private let liveStreamSubject = PassthroughSubject<CIImage, Never>()
    
    private let sessionQueue: DispatchQueue
    private let videoDataOutputQueue: DispatchQueue
    
    init(sessionQueue: DispatchQueue? = nil) {
        self.sessionQueue = sessionQueue ?? DispatchQueue(label: "Camera.session.queue", qos: .userInitiated)
        videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated)
    }
    
    // MARK: Public Interface
    
    func run() async {
        let authorized = await checkAuthorization()
        guard authorized else {
            logger.error("Camera access was not authorized.")
            return
        }
        
        guard configureCaptureSession() else {
            logger.error("Failed to configure camera.")
            return
        }

        guard !captureSession.isRunning else {
            logger.warning("Capture session already running.")
            return
        }
        
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    func stop() {
        guard captureSession.isRunning else { return }
        
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
    
    func suspend() {
        isCaptureSessionConnectionEnabled = false
    }
    
    func resume() {
        isCaptureSessionConnectionEnabled = true
    }
    
    var isRunning: Bool {
        captureSession.isRunning && isCaptureSessionConnectionEnabled
    }
    
    private(set) lazy var liveStream: AnyPublisher<CIImage, Never> = liveStreamSubject.eraseToAnyPublisher()
    
    // MARK: Permissions
    
    private func checkAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            logger.debug("Camera access authorized.")
            return true
        case .notDetermined:
            logger.debug("Camera access not determined.")
            sessionQueue.suspend()
            let status = await AVCaptureDevice.requestAccess(for: .video)
            sessionQueue.resume()
            return status
        case .denied:
            logger.debug("Camera access denied.")
            return false
        case .restricted:
            logger.debug("Camera library access restricted.")
            return false
        @unknown default:
            return false
        }
    }
    
    // MARK: Camera Configuration
    
    private var isCaptureSessionConnectionEnabled: Bool {
        get {
            guard let connection = videoOutput?.connection(with: .video) else { return false }
            return connection.isEnabled
        }
        set {
            guard let connection = videoOutput?.connection(with: .video) else { return }
            connection.isEnabled = newValue
        }
    }
    
    private func configureCaptureSession() -> Bool {
        guard !isCaptureSessionConfigured else {
            return true
        }
                
        self.captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
        }
        
        guard
            let captureDevice = findCaptureDevice(),
            let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
        else {
            logger.error("Failed to obtain video input.")
            return false
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
  
        guard captureSession.canAddInput(deviceInput) else {
            logger.error("Unable to add device input to capture session.")
            return false
        }
        guard captureSession.canAddOutput(videoOutput) else {
            logger.error("Unable to add video output to capture session.")
            return false
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        
        self.deviceInput = deviceInput
        self.videoOutput = videoOutput
        
        isCaptureSessionConfigured = true
        
        return true
    }
    
    private func findCaptureDevice() -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified)
        return discoverySession.devices.first ?? .default(for: .video)
    }
}

extension CameraDevice: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = .portrait
        }
        let image = CIImage(cvPixelBuffer: pixelBuffer)
        liveStreamSubject.send(image)
    }
}
