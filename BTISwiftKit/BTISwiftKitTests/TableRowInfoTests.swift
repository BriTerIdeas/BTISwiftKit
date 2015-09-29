//
//  TableRowInfoTests.swift
//  BTISwiftKit
//
//  Created by Brian Slick on 9/28/15.
//  Copyright © 2015 BriTer Ideas LLC. All rights reserved.
//

import XCTest
import BTISwiftKit

class TableRowInfoTests: XCTestCase
{

    var tableRowInfo: TableRowInfo? = TableRowInfo()
    var isBlockExecuted = false
    
    override func setUp()
    {
        super.setUp()

        let rowInfo = TableRowInfo()
        tableRowInfo = rowInfo
        
        rowInfo.identifier = "Test Info Identifier"
        rowInfo.representedObject = "Test Info Represented Object"
        
        rowInfo.text = "Test Info Text"
        rowInfo.detailText = "Test Info Detail Text"
        rowInfo.cellAccessoryType = .Checkmark
        rowInfo.rowHeight = 15.0
        
        rowInfo.image = UIImage()
        rowInfo.imageName = "file.jpg"
        rowInfo.imageFileURL = NSURL(string: "file.jpg")
        
        rowInfo.rowSelectionBlock = {
            self.isBlockExecuted = true
        }
        
        rowInfo.rowAccessorySelectionBlock = {
            self.isBlockExecuted = true
        }
    }
    
    override func tearDown()
    {
        super.tearDown()
        
        tableRowInfo = nil
        isBlockExecuted = false
    }

    func testThatAllValuesAreClearedUponReset()
    {
        let rowInfo = tableRowInfo!
        
        rowInfo.reset()
        
        XCTAssertNil(rowInfo.identifier, "Identifier was not cleared out")
        
        XCTAssertNil(rowInfo.representedObject, "Represented object was not cleared out");
        
        XCTAssertNil(rowInfo.text, "Text was not cleared out");
        XCTAssertNil(rowInfo.detailText, "Detail text was not cleared out");
        XCTAssertNil(rowInfo.cellAccessoryType, "Cell accessory was not cleared out");
        XCTAssertEqual(0.0, rowInfo.rowHeight, "Row height was not reset");
        
        XCTAssertNil(rowInfo.image, "Image was not cleared out");
        XCTAssertNil(rowInfo.imageName, "Image name was not cleared out");
        XCTAssertNil(rowInfo.imageFileURL, "Image file URL was not cleared out");
        
        XCTAssertNil(rowInfo.rowSelectionBlock, "Row selection block was not cleared out");
        XCTAssertNil(rowInfo.rowAccessorySelectionBlock, "Row accessory selection block was not cleared out");

    }
    
    func testCellPopulation()
    {
        let rowInfo = tableRowInfo!
        
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Test")
        rowInfo.populateCell(cell)
        
        XCTAssertEqual("Test Info Text", cell.textLabel?.text, "Cell's text label was not populated");
        XCTAssertEqual("Test Info Detail Text", cell.detailTextLabel?.text, "Cell's detail text label was not populated");
        XCTAssertEqual(UITableViewCellAccessoryType.Checkmark, rowInfo.cellAccessoryType, "Cell accessory was not defined");
        XCTAssertNotNil(cell.imageView?.image, "Cell should have an image");
    }
    
    func testRowSelection()
    {
        tableRowInfo?.safelyPerformRowSelectionBlock()
        
        XCTAssertTrue(isBlockExecuted, "Block was not exectuted")
    }
    
    func testRowAccessorySelection()
    {
        tableRowInfo?.safelyPerformRowAccessorySelectionBlock()
        
        XCTAssertTrue(isBlockExecuted, "Block was not exectuted")
    }

}
