//
//  Weather_Hiteksha_IOSDemoTests.swift
//  Weather_Hiteksha_IOSDemoTests
//
//  Created by Hiteksha G. Kathiriya on 20/10/18.
//  Copyright © 2018 Hiteksha G. Kathiriya. All rights reserved.
//

import XCTest
@testable import Weather_Hiteksha_IOSDemo

class Weather_Hiteksha_IOSDemoTests: XCTestCase {
    
   
    var tableView: UITableView!
    var dataSource: UITableViewDataSource!
    var delegate: UITableViewDelegate!
    var viewController: ViewController!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle(for: ViewController.self))
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        viewController = navigationController.topViewController as! ViewController
        
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        // Test and Load the View at the Same Time!
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(viewController.view)
        
        viewController.loadViewIfNeeded()
        tableView = viewController.objtbl
        guard let ds = tableView.dataSource else
        {
            return XCTFail("Controller's table view should have a Uitableview data source")
        }
        dataSource = ds
        delegate = tableView.delegate
    }
    func testTableViewHasCells() {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        XCTAssertNotNil(cell,
                        "TableView should be able to dequeue cell with identifier: 'cell'")
    }
    

    func testTableViewDelegateIsViewController() {
        XCTAssertTrue(delegate === viewController,
                      "Controller should be delegate for the tableView")
    }
    func testString()
    {
        let value = 3
        let CountValue = value.Sqaure()
        XCTAssertEqual(CountValue, 9)
    }
    func testExample()
    {
        var helloword : String?
        XCTAssertNil(helloword)
        
        helloword = "Hello world"
        XCTAssertEqual(helloword, "Hello world")
        
    }
    
}
