//
//  HostViewModelAdapter.swift
//  PeersGameDraw
//
//  Created by Johanna Reiting on 25.08.19.
//  Copyright © 2019 Johanna Reiting. All rights reserved.
//

import Foundation

protocol HostViewModelAdapter {
    var randomImage: String? { get set }
    func nextImage(_ image: String)
}
