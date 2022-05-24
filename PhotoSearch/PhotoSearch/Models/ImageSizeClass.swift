//
//  ImageSizeClass.swift
//  PhotoSearch
//
//  Created by bnulo on 5/22/22.
//

import Foundation

class ImageSizeModel {
     
    let suffix: String
    
    init(imageSize: SizeClass.Thumbnail) {
        self.suffix = imageSize.rawValue
    }
    init(imageSize: SizeClass.Small) {
        self.suffix = imageSize.rawValue
    }
    init(imageSize: SizeClass.Medium) {
        self.suffix = imageSize.rawValue
    }
    init(imageSize: SizeClass.Large) {
        self.suffix = imageSize.rawValue
    }
    init(imageSize: SizeClass.ExtraLarge) {
        self.suffix = imageSize.rawValue
    }
    init(imageSize: SizeClass.Original) {
        self.suffix = imageSize.rawValue
    }
}
enum SizeClass {
    enum Thumbnail: String {
        case px75CroppedSquare = "s"
        case px150CroppedSquare = "q"
        case px100 = "t"
    }
    enum Small: String {
        case px240 = "m"
        case px320 = "n"
        case px400 = "w"
    }
    enum Medium: String {
        case px500 = ""
        case px640 = "z"
        case px800 = "c"
    }
    enum Large: String {
        case px1024 = "b"
        case px1600 = "h"
        case px2048 = "k"
    }
    enum ExtraLarge: String {
        case px3072 = "3k"
        case px4096 = "4k"
        case px4096AspectRatio21 = "f"
        case px5120 = "5k"
        case px6144 = "6k"
    }
    enum Original: String {
        case original = "o"
    }
}
