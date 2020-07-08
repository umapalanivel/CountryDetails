//
//  CountryDetailsTests.swift
//  CountryDetailsTests
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import XCTest
@testable import CountryDetails

class CountryDetailsTests: XCTestCase {
    
    let networkManager = NetworkProcessor(url: URL(string: Url.apiURL)!)
       
       var numberOfRows = [Rows]()
       func testApiCall() {

           let expectation = XCTestExpectation(description: "response")
           networkManager.downLoadJSONFromURL{(results) in
            self.numberOfRows = results.rows!
               
               
           }
           
           XCTAssertNotNil(numberOfRows)
           wait(for: [expectation], timeout: 1)
       }
       


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override func startLoading() {
        
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
    }
    
    override func stopLoading() {
        // Required by the superclass.
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
}
