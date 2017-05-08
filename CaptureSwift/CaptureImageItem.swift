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

class CaptureImageItem: CaptureItem {
        
    var image: UIImage? {
        get {
            return self.readImage()
        }
    }
    
    override init() {
    }
    
    convenience init(image: UIImage) {        
        self.init(name: CaptureFileManager.imageName(), image: image)
    }
    
    /**
     This method takes name and image and save the image with the given name.
     */
    convenience init(name: String, image: UIImage) {
        self.init()
        self.name = name
        self.saveImage(image: image)
        
        if let thumbnail = self.getThumbnail(image: image) {
            self.thumbnailImage = thumbnail
            self.saveThumbnail()
        }
    }
    
    /**
     This method takes image name and allows user to read the image from the temporary directory with the given name.
     */
    convenience init(name: String) {
        self.init()
        self.name = name
        
        if let thumbnail = self.readThumbnail() {
            self.thumbnailImage = thumbnail
        }
        else if let image = self.image {
            if let thumbnail = self.getThumbnail(image: image) {
                self.thumbnailImage = thumbnail
                self.saveThumbnail()
            }
        }
    }
    
    private func saveImage(image: UIImage) {
        let _ = CaptureFileManager.save(image: image, withName: name)
    }
    
    private func readThumbnail() -> UIImage? {
        return CaptureFileManager.getImage(file: thumbnailName)
    }
    
    private func readImage() -> UIImage? {
        return CaptureFileManager.getImage(file: name)
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
