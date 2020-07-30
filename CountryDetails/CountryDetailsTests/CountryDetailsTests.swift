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
  
  /*Test case for mock response*/
  func testMockCallbacks() {
    let onRequestExpectation = expectation(description: "Data request should start")
    let completionExpectation = expectation(description: "Data request should succeed")
    var mock = Mock(dataType: .json, statusCode: 200, data: [.get: Data()])
    mock.onRequest = { _, _ in
      onRequestExpectation.fulfill()
    }
    mock.completion = {
      completionExpectation.fulfill()
    }
    mock.register()
    URLSession.shared.dataTask(with: mock.request).resume()
    wait(for: [onRequestExpectation, completionExpectation], timeout: 2.0, enforceOrder: true)
  }
  
  /*Test case for sample image download check*/
  func testSampleImageDownload() {
    let expectation = self.expectation(description: "Image Request")
    let originalURL = URL(string:"https://images.findicons.com/files/icons/662/world_flag/128/flag_of_canada.png")
    Mock(fileExtensions: "png", dataType: .imagePNG, statusCode: 200, data: [
      .get: MockDataModel.imageFileUrl.data
    ]).register()
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [MockingURLProtocol.self]
    let urlSession = URLSession(configuration: configuration)
    urlSession.dataTask(with: originalURL!) { (data, _, error) in
      XCTAssert(error == nil)
      let image: UIImage = UIImage(data: data!)!
      let sampleImage: UIImage = UIImage(contentsOfFile: MockDataModel.imageFileUrl.path)!
      XCTAssert(image.size == sampleImage.size, "Image should be returned mocked")
      expectation.fulfill()
    }.resume()
    waitForExpectations(timeout: 10.0, handler: nil)
  }
  
}

