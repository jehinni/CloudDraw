//
//  ImageGenerator.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 24.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation

class ImageGenerator {
    private static let imageElements = ["apple", "book", "bowtie", "candle", "cloud", "cup", "door", "envelope", "eyeglasses", "guitar", "hammer", "hat", "ice cream", "leaf", "lightning", "pants", "scissors", "star", "tree", "t-shirt"]
    
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
