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
    var imageData: Data?
    
    init(text: String, imageData: Data?) {
        self.text = text
        self.imageData = imageData
    }
}
