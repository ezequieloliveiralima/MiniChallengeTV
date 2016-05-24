//
//  MiniChallengeTVTests.swift
//  MiniChallengeTVTests
//
//  Created by Ezequiel de Oliveira Lima on 13/05/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import XCTest
@testable import MiniChallengeTV

class MiniChallengeTVTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testHistoricCount() {
        assert(LocalStorage.fetchHistoric().count > 0)
    }
    
    func testInheranceCoreData() {
        assert(CoreDataManager.instance.all("CDProduct").count > 0)
    }
    
    func testQRCode() {
        assert(QRCode(content: "http://www.google.com.br").generate() != nil)
    }
    
    func testImageCache() {
        let expectation = expectationWithDescription("image api")
        var image: UIImage?
        MainConnector.getImage(nil) { (img) in
            image = img
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(1) { (error) in
            assert(error == nil)
        }
        
        XCTAssertNil(image, "image is nil")
    }
    
    func testTopProducts() {
        let expectation = expectationWithDescription("top products")

        MainConnector.getListTopProducts([]) { (list) in
            assert(list.list.count > 0)
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertNil(error, "error is nil")
        }
    }
    
    func testTopCategories() {
        let expectation = expectationWithDescription("top categories")
        
        MainConnector.getListTopCategories([]) { (list) in
            assert(list.list.count > 0)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertNil(error, "error is nil")
        }
    }
    
    func testNumOffers() {
        let expectation = expectationWithDescription("top categories")
        
        MainConnector.getProductOffers(615241, params: []) { (list) in
            assert(list.offers.count == 16)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(2) { (error) in
            XCTAssertNil(error, "error is nil")
        }
    }
}
