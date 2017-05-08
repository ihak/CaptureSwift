//
//  CaptureVideoItem.swift
//  CaptureSwift
//
//  Created by Hassan Ahmed Khan on 1/31/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CaptureVideoItem: CaptureItem {
    var url: URL!
    
    convenience override init() {
        self.init(url: CaptureFileManager.videoPath()!)
    }
    
    init(url: URL) {
        super.init()
        self.name = url.lastPathComponent
        self.url = url
        
        if let thumb = self.generateThumbnail(url: self.url) {
            thumbnailImage = thumb
            saveThumbnail()
        }
        
        let _ = CaptureFileManager.sizeOf(itemAtPath: self.url)
    }
    
    convenience init(name: String) {
            self.init(url: CaptureFileManager.temporaryPath(name)!)
    }
    
    func generateThumbnail(url: URL) -> UIImage? {
        var image: UIImage?
        
        let asset = AVURLAsset(url: url, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        
        if let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil) {
            image = UIImage(cgImage: cgImage)
        }
        return image
    }
}
