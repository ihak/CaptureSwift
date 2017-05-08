//
//  CaptureItemCollectionCell.swift
//  CaptureSwift
//
//  Created by Hassan Ahmed Khan on 4/23/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import UIKit

class CaptureItemCollectionCell: UICollectionViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var captureImage: UIImageView!
    @IBOutlet var typeIcon: UIImageView!
    
    var model: CaptureItem? {
        willSet {
            if newValue != nil {
                self.captureImage.image = newValue!.thumbnailImage
                
                if let _ = newValue as? CaptureVideoItem {
                    self.typeIcon.image = #imageLiteral(resourceName: "video-icon")
                }
                else {
                    self.typeIcon.image = nil
                }
            }
        }
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.containerView.layer.borderWidth = 3
                self.containerView.layer.borderColor = UIColor.red.cgColor
            }
            else {
                self.containerView.layer.borderWidth = 0
            }
        }
    }
}
