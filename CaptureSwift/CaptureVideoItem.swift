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
    var url: URL?
    
    init(url: URL) {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd-hh:mm:ss"
        let name = dateformat.string(from: Date())

        super.init()
        self.name = name + ".mp4"
        
        // Rename video by moving it to a different path from default path
        if let path = CaptureFileManager.rename(at: url, to: self.name) {
            self.url = path
            
            if let thumb = self.generateThumbnail(url: path) {
                thumbnailImage = thumb
            }
        }
    }
    
    func generateThumbnail(url: URL) -> UIImage? {
        var image: UIImage?
        
        let asset = AVURLAsset(url: url, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        
        if let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil) {
            // !! check the error before proceeding
            image = UIImage(cgImage: cgImage)
            // lay out this image view, or if it already exists, set its image property to uiImage
        }
        return image
    }
}
