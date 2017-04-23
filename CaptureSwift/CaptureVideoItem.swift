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
    
    init(url: URL) {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd-hh:mm:ss"
        let name = dateformat.string(from: Date())

        super.init()
        self.name = name + ".mp4"
        self.url = url
        
        if let thumb = self.generateThumbnail(url: self.url) {
            thumbnailImage = thumb
        }
        
        let _ = CaptureFileManager.sizeOf(itemAtPath: self.url)

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
