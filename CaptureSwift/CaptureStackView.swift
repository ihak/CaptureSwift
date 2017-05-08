//
//  CaptureStackView.swift
//  CaptureSwift
//
//  Created by Hassan Ahmed Khan on 1/25/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import Foundation
import UIKit

protocol CaptureStackViewDelegate {
    func captureStackViewDidTap(captureStackView: CaptureStackView);
}

class CaptureStackView: UIView, CaptureStackDelegate {
    @IBOutlet var imageView: UIImageView!
    
    var captureStack = CaptureStack()
    var delegate: CaptureStackViewDelegate?
    
    //MARK: - Override Functions
    override func awakeFromNib() {
        captureStack.delegate = self
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTap)))
        captureStack.loadTemporaryDirectoryImages()
    }

    //MARK: - IBActions
    
    //MARK: - Other Functions
    func handleTap() {
        delegate?.captureStackViewDidTap(captureStackView: self)
    }
    
    //MARK: - CaptureStackDelegate
    func didAddItem(item: CaptureItem) {
        DispatchQueue.main.async {
            self.imageView.image = item.thumbnailImage
        }
    }
    
    func didUpdateCaptureStack(captureStack: CaptureStack) {
        if let item = captureStack.list.first {
            self.imageView.image = item.thumbnailImage
        }
    }
}
