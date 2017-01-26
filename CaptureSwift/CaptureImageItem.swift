//
//  CaptureImageItem.swift
//  CaptureSwift
//
//  Created by Hassan Ahmed Khan on 1/25/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import Foundation
import UIKit
import ImageIO

class CaptureImageItem {
    var imageName: String
    
    var thumbnailName: String {
        return self.imageName + "-thumb"
    }
    
    var imageThumbnail: UIImage
    
    var image: UIImage? {
        get {
            return self.readImage()
        }
    }
    
    init() {
        imageName = ""
        imageThumbnail = UIImage()
    }
    
    convenience init(name: String, image: UIImage) {
        self.init()
        self.imageName = name
        self.saveImage(image: image)
        
        if let thumbnail = self.getThumbnail(image: image) {
            self.imageThumbnail = thumbnail
            self.saveThumbnail()
        }
    }
    
    convenience init(name: String) {
        self.init()
        self.imageName = name
        
        if let thumbnail = self.readThumbnail() {
            self.imageThumbnail = thumbnail
        }
    }
    
    func save() {
        self.saveThumbnail()
    }
    
    private func saveImage(image: UIImage) {
        let _ = CaptureFileManager.save(image: image, withName: imageName)
    }
    
    private func saveThumbnail() {
        let _ = CaptureFileManager.save(image: imageThumbnail, withName: thumbnailName)
    }
    
    private func readThumbnail() -> UIImage? {
        return CaptureFileManager.getImage(file: thumbnailName)
    }
    
    private func readImage() -> UIImage? {
        return CaptureFileManager.getImage(file: imageName)
    }
    
    private func getThumbnail(image: UIImage) -> UIImage? {
        if let imageData = UIImageJPEGRepresentation(image, 1.0) {
            if let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) {
                let options: [NSString: Any] = [
                    kCGImageSourceThumbnailMaxPixelSize: max(image.size.width, image.size.height) / 2.0,
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceCreateThumbnailWithTransform: true
                ]
                
                let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary?).flatMap { UIImage(cgImage: $0) }
                return scaledImage
            }
        }
        return nil
    }
}
