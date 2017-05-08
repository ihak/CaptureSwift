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
    
    private var _list = [CaptureItem]()
    
    var list: [CaptureItem] { return self._list }
    
    
    var delegate: CaptureStackDelegate?
    
    init() {
    }
    
    func loadTemporaryDirectoryImages() {
        let list = CaptureFileManager.listFilesInTempDirectory()
        
        for item in list {
            push(name: item)
        }
    }
    
    func push(captureItem: CaptureItem) {
        _list.insert(captureItem, at: 0)
        delegate?.didAddItem(item: list.first!)
    }
    
    func push(image: UIImage) {
        push(captureItem: CaptureImageItem(image: image))
    }
    
    func push(name: String) {
        if name.hasSuffix("-video.mp4") {
            push(captureItem: CaptureVideoItem(name: name))
        }
        else {
            push(captureItem: CaptureImageItem(name: name))
        }
    }
    
    func push(url: URL) {
        push(captureItem: CaptureVideoItem(url: url))
    }
    
    func pop() -> CaptureItem {
        return _list.remove(at: 0)
    }
    
    func removeItem(at: Int) -> CaptureItem? {
        if at < _list.count {
            return _list.remove(at: at)
        }
        return nil
    }
    
    func removeItems(set: Set<Int>) {
        for index in set {
            _list.remove(at: index)
        }
        delegate?.didUpdateCaptureStack(captureStack: self)
    }
}

protocol CaptureStackDelegate {
    func didAddItem(item: CaptureItem)
    func didUpdateCaptureStack(captureStack: CaptureStack)
}
