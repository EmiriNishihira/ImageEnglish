//
//  Item.swift
//  ImageEnglish
//
//  Created by えみり on 2024/12/14.
//

import Foundation
import SwiftData

@Model
final class Item {
    var text: String
    var imageUrl: URL?
    
    init(text: String, imageUrl: URL? = nil) {
        self.text = text
        self.imageUrl = imageUrl
    }
}
