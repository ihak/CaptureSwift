//
//  CaptureStack.swift
//  CaptureSwift
//
//  Created by Hassan Ahmed Khan on 1/24/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import Foundation
import UIKit

class CaptureStack {
    // 1. Add an image to the stack
    // 2. Save the added image on the file and save the thumbnail in the stack
    // 3. return list of thumbnails
    // 4. return full image
    // 5. will contain the objects of CaptureImageItem
    // 
    
    var list = [CaptureItem]()
    var delegate: CaptureStackDelegate?
    
    init() {
    }
    
    func push(image: UIImage) {
        list.insert(CaptureImageItem(image: image), at: 0)
        delegate?.didAddItem(item: list.first!)
    }
    
    func push(url: URL) {
        list.insert(CaptureVideoItem(url: url), at: 0)
        delegate?.didAddItem(item: list.first!)
    }
    
    func pop() -> CaptureItem {
        return list.remove(at: 0)
    }
}

protocol CaptureStackDelegate {
    func didAddItem(item: CaptureItem)
}
