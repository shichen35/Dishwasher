//
//  DishwasherTests.swift
//  DishwasherTests
//
//  Created by Chen Shi on 3/13/17.
//  Copyright © 2017 Chen Shi. All rights reserved.
//

import XCTest
@testable import Dishwasher

class DishwasherTests: XCTestCase {
    
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
    
    func testSearchDishwasherAPIRequest() {
        // Define an expectation
        let exp = expectation(description: "Search Dishwasher API Request")
        // Set up the URL request
        let urlStr = "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20"
        guard let url = URL(string: urlStr) else {
            print("Error: cannot create URL")
            return
        }
        
        let defaultSession = URLSession(configuration: .default)
        
        let dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        _ = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                        exp.fulfill()
                    } catch {
                        print(error)
                    }
                    
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            dataTask.cancel()
        }
    }
    
    func testProductPageAPIRequest() {
        // Define an expectation
        let exp = expectation(description: "Search Dishwasher API Request")
        // Set up the URL request
        let urlStr = "https://api.johnlewis.com/v1/products/1913267?key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb"
        guard let url = URL(string: urlStr) else {
            print("Error: cannot create URL")
            return
        }
        
        let defaultSession = URLSession(configuration: .default)
        
        let dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let _ = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                        exp.fulfill()
                    } catch {
                        print(error)
                    }
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            dataTask.cancel()
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
