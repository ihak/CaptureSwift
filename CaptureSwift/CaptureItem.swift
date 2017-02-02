//
//  CaptureItem.swift
//  CaptureSwift
//
//  Created by Hassan Ahmed Khan on 1/31/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import Foundation
import UIKit

class CaptureItem {
    var thumbnailImage: UIImage
    var name: String

    var thumbnailName: String {
        return self.name + "-thumb.png"
    }

    init() {
        thumbnailImage = UIImage()
        name = ""
    }
    
    func saveThumbnail() {
        let _ = CaptureFileManager.save(image: thumbnailImage, withName: thumbnailName)
    }    
}
