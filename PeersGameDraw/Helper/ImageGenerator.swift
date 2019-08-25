//
//  ImageGenerator.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 24.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation

class ImageGenerator {
    private static let imageElements = ["apple", "candle", "lightning", "pants"]
    
    static func generateRandomImages(_ amount: Int) -> [String] {
        var randomImages = [String]()
        
        var counter = 0
        while counter < amount {
            let randomImage = imageElements.randomElement() ?? "No Image Elements"
            randomImages.append(randomImage)
            counter += 1
        }
        
        return randomImages
    }
    
}
