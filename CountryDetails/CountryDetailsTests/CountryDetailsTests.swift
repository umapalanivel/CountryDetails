//
//  CountryDetailsTests.swift
//  CountryDetailsTests
//
//  Created by uma palanivel on 26/06/20.
//  Copyright © 2020 umapalanivel. All rights reserved.
//

import XCTest

import Mocker

class CountryDetailsTests: XCTestCase {
    
    static let titleValue = "About Canada"
    struct WebDetails {
        let title: String?
        let rows: [[String:Any]]?
        
        init(jsonDictionary: [String: Any]) {
            title = jsonDictionary["title"] as? String
            rows = jsonDictionary["rows"] as? [[String:Any]]
        }
    }
   

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /*Test case for valid server response*/
    func testJSONResponse() {
          let expectation = self.expectation(description: "API RESPONSE")
          let originalURL = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
         
              let mockData = Mock(url: originalURL, dataType: .json, statusCode: 200, data: [
              .get: MockDataModel.mockJSON.data
              ]
          )
              mockData.register()
          
          URLSession.shared.dataTask(with: originalURL) { (data, _, _) in

              guard let data = data, let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
                  XCTFail("Wrong data response")
                  expectation.fulfill()
                  return
              }
              
           
              let framework = WebDetails.init(jsonDictionary: jsonDictionary)
             
            XCTAssert(framework.title == CountryDetailsTests.titleValue)
              XCTAssert(framework.rows!.count > 0)
              
              
              expectation.fulfill()
          }.resume()
          
          waitForExpectations(timeout: 10.0, handler: nil)
      }
    
    /*Test case for internal server error*/
    func testMockReturningError() {
           let expectation = self.expectation(description: "Data request should succeed")
           let originalURL = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!

           enum TestExampleError: Error {
               case example
           }
           
           Mock(url: originalURL, dataType: .json, statusCode: 500, data: [.get: Data()], requestError: TestExampleError.example).register()
           
           URLSession.shared.dataTask(with: originalURL) { (data, urlresponse, err) in

               XCTAssertNil(data)
               XCTAssertNil(urlresponse)
               XCTAssertNotNil(err)
               if let err = err {
                   XCTAssertEqual("example", String(describing: err))
               }
               
               expectation.fulfill()
           }.resume()
           
           waitForExpectations(timeout: 10.0, handler: nil)
       }
    
    /*Test case for successful response code*/
    func testOnRequestExpectation() {
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!

        var mock = Mock(url: url, dataType: .json, statusCode: 200, data: [.get: Data()])
        let expectation = expectationForRequestingMock(&mock)
        mock.register()

        URLSession.shared.dataTask(with: URLRequest(url: url)).resume()

        wait(for: [expectation], timeout: 2.0)
    }


}

