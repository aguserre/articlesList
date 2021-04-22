//
//  Articles_List_Tests.swift
//  Articles List_Tests
//
//  Created by Agustin Errecalde on 22/04/2021.
//

import XCTest
import UIKit

class Articles_List_Tests: XCTestCase {
    
    var sut: URLSession!
    let urlString =
    "https://hn.algolia.com/api/v1/search_by_date?query=mobile"

    override func setUpWithError() throws {
      try super.setUpWithError()
      sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
      sut = nil
      try super.tearDownWithError()
    }
    
    func testValidApiCallGetsHTTPStatusCode200() throws {
        let url = URL(string: urlString)!
        let promise = expectation(description: "Status code: 200")

        let dataTask = sut.dataTask(with: url) { _, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
    
    func testApiCallCompletes() throws {
      let url = URL(string: urlString)!
      let promise = expectation(description: "Completion handler invoked")
      var statusCode: Int?
      var responseError: Error?

      let dataTask = sut.dataTask(with: url) { _, response, error in
        statusCode = (response as? HTTPURLResponse)?.statusCode
        responseError = error
        promise.fulfill()
      }
      dataTask.resume()
      wait(for: [promise], timeout: 5)

      XCTAssertNil(responseError)
      XCTAssertEqual(statusCode, 200)
    }

}
