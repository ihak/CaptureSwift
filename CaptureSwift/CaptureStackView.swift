//
//  CaptureStackView.swift
//  CaptureSwift
//
//  Created by Hassan Ahmed Khan on 1/25/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import Foundation
import UIKit

class CaptureStackView: UIView, CaptureStackDelegate {
    @IBOutlet var imageView: UIImageView!
    
    var captureStack = CaptureStack()
    
    //MARK: - Override Functions
    override func awakeFromNib() {
        captureStack.delegate = self
    }

    //MARK: - IBActions
    
    //MARK: - Other Functions
    
    //MARK: - CaptureStackDelegate
    func didAddItem(item: CaptureItem) {
        DispatchQueue.main.async {
            self.imageView.image = item.thumbnailImage
        }
    }
}
