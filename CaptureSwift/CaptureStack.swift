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
    
    var list = [CaptureImageItem]()
    var delegate: CaptureStackDelegate?
    
    init() {
    }
    
    func push(image: UIImage) {
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let name = dateformat.string(from: Date())
        
        list.insert(CaptureImageItem(name: name, image: image), at: 0)
        delegate?.didAddItem(item: list.first!)
    }
    
    func pop() -> CaptureImageItem {
        return list.remove(at: 0)
    }
}

protocol CaptureStackDelegate {
    func didAddItem(item: CaptureImageItem)
}
