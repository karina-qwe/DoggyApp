//
//  LiveImageClassifing.swift
//  Doggy
//
//  Created by Karyna Khotin on 19.05.2023.
//

import Combine

protocol LiveImageClassifing {
    func run() async
    func stop() async
    
    var predictionsStream: AnyPublisher<[Prediction], Never> { get }
}
