//
//  CaptureSwiftTests.swift
//  CaptureSwiftTests
//
//  Created by Hassan Ahmed Khan on 1/14/17.
//  Copyright © 2017 Hassan Ahmed Khan. All rights reserved.
//

import XCTest
@testable import CaptureSwift

class CaptureSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCFMDocumentPath() {
        let path = CaptureFileManager.documentPath()
        print("Path: \(path)")
        XCTAssertNotNil(path)
    }
    
    func testCFMTempPath() {
        let path = CaptureFileManager.temporaryPath()
        print("Path: \(path)")
        XCTAssertNotNil(path)
    }
    
    func testCFMDocumentPathForFile() {
        let fileName = "abc.png"
        let path = CaptureFileManager.documentPath(fileName)
        print("Path: \(path)")
        XCTAssertNotNil(path)
    }
    
    func testCFMTemporaryPathForFile() {
        let fileName = "abc.png"
        let path = CaptureFileManager.temporaryPath(fileName)
        print("Path: \(path)")
        XCTAssertNotNil(path)
    }
    
    func testSaveImage() {
        XCTAssert(CaptureFileManager.save(image: UIImage(named: "temp")!, withName: "abc.jpeg"))
    }
    
    func testRemoveImage() {
        XCTAssert(CaptureFileManager.remove(file: "abc.jpeg"))
    }
    
    func testTempDirectoryContents() {
        XCTAssertGreaterThan(CaptureFileManager.listFilesInTempDirectory().count, 0)
    }
    
    func testEmptyTempDirectory() {
        CaptureFileManager.emptyTempDirectory()
        XCTAssertEqual(CaptureFileManager.listFilesInTempDirectory().count, 0)
    }
    
    func testGetImage() {
        XCTAssertNotNil(CaptureFileManager.getImage(file: "abc.jpeg"))
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
