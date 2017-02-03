//
//  CaptureFileManager.swift
//  CaptureSwift
//
//  Created by Hassan Ahmed Khan on 1/14/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import Foundation
import UIKit

enum FileType {
    case image
    case video
}

class CaptureFileManager: NSObject {
    // 1. save file at path
    // 2. remove file at path
    // 3. get file at path
    // 4. temporary directory path
    // 5. save file in temporary directory
    // 6. remove all files in temporary directory
    // 7. get all files in temporary directory of type
    
    private class func removeItemAtPath(_ path: String) -> Bool {
        let filemanager = FileManager.default
        if filemanager.fileExists(atPath: path) {
            do {
                try filemanager.removeItem(atPath: path)
                return true
            }
            catch {
                print("[Camera engine] Error remove path :\(path)")
            }
        }
        
        return false
    }

    private class func appendPath(_ rootPath: String, pathFile: String) -> String {
        var destinationPath: String
        
        if rootPath.hasSuffix("/") {
            destinationPath = rootPath + "\(pathFile)"
        }
        else {
            destinationPath = rootPath + "/\(pathFile)"
        }
        
        return destinationPath
    }

    public class func documentPath() -> String? {
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last {
            return path
        }
        return nil
    }
    
    public class func temporaryPath() -> String {
        return NSTemporaryDirectory()
    }
    
    public class func documentPath(_ file: String) -> URL? {
        if let path = self.documentPath() {
            return URL(fileURLWithPath: self.appendPath(path, pathFile: file))
        }
        return nil
    }
    
    public class func temporaryPath(_ file: String) -> URL? {
        return URL(fileURLWithPath: self.appendPath(self.temporaryPath(), pathFile: file))
    }
    
    public class func remove(fromTempDirectory file: String) -> Bool {
        let path = appendPath(temporaryPath(), pathFile: file)
        return removeItemAtPath(path)
    }
    
    public class func remove(fromDocumentsDirectory file: String) -> Bool {
        if let documentPath = documentPath() {
            let path = appendPath(documentPath, pathFile: file)
            return removeItemAtPath(path)
        }
        return false
    }
    
    public class func listFilesInTempDirectory() -> [String] {
        let fileManager = FileManager.default
        if let list = try? fileManager.contentsOfDirectory(atPath: temporaryPath()) {
            return list
        }
        return [String]()
    }
    
    public class func emptyTempDirectory() {
        let fileManager = FileManager.default
        for item in listFilesInTempDirectory() {
            let path = appendPath(temporaryPath(), pathFile: item)
            do {
                try fileManager.removeItem(atPath: path)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public class func sizeOf(itemAtPath path: URL) -> UInt64 {
        var fileSize = UInt64(0)
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: path.path)
            fileSize = attr[FileAttributeKey.size] as! UInt64
            
            let sizeMB = fileSize/1024/1024
            
            print("Name: \(path.lastPathComponent): Size: \(sizeMB) MB")
        } catch {
            print("Error: \(error)")
        }
        
        return fileSize
    }
}

extension CaptureFileManager {
    public class func save(image: UIImage, withName fileName: String) -> Bool {
        if let path = self.temporaryPath(fileName) {
            if let data = UIImageJPEGRepresentation(image, 1.0) {
                do {
                    try data.write(to: path, options: .atomic)
                    return true
                }
                catch let error {
                    print(error.localizedDescription)
                    return false
                }
            }
        }
        return false
    }
    
    public class func remove(file: String) -> Bool {
        return remove(fromTempDirectory: file)
    }
    
    public class func getImage(file: String) -> UIImage? {
        if let path = temporaryPath(file) {
            return UIImage.init(contentsOfFile: path.path)
        }
        return nil
    }
    
    public class func rename(at srcPath: URL, to name: String) -> URL? {
        var url: URL?
        
        if let path = temporaryPath(name) {
            url = path
            
            do {
                try FileManager.default.moveItem(at: srcPath, to: path)
                print("Video moved to: \(path.absoluteString)")
            } catch  {
                print(error.localizedDescription)
            }
        }
        
        return url
    }
}
