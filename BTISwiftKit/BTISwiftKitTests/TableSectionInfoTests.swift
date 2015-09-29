//
//  TableSectionInfoTests.swift
//  BTISwiftKit
//
//  Created by Brian Slick on 9/28/15.
//  Copyright © 2015 BriTer Ideas LLC. All rights reserved.
//

import XCTest
import BTISwiftKit

class TableSectionInfoTests: XCTestCase
{
    var tableSectionInfo: TableSectionInfo? = TableSectionInfo()
    
    override func setUp()
    {
        super.setUp()

        setUpBasicScenario()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }

    func setUpBasicScenario()
    {
        let sectionInfo = TableSectionInfo()
        tableSectionInfo = sectionInfo
        
        sectionInfo.identifier = "Test Info Identifier"
        sectionInfo.representedObject = "Test Info Represented Object"
        
        let row1 = TableRowInfo()
        row1.identifier = "Red"
        
        let row2 = TableRowInfo()
        row2.identifier = "Green"
        
        let row3 = TableRowInfo()
        row3.identifier = "Blue"
        
        let rows = [ row1, row2, row3 ]
        sectionInfo.addRowInfosFromArray(rows)
        
        sectionInfo.headerTitle = "Test Header Title"
        sectionInfo.footerTitle = "Test Footer Title"
        sectionInfo.sectionIndexTitle = "G"
    }
    
    // MARK: - Basic Scenario Tests
    
    func testThatAllValuesAreClearedUponReset()
    {
        let sectionInfo = tableSectionInfo!
        
        sectionInfo.reset()
        
        XCTAssertNil(sectionInfo.identifier, "Identifier was not cleared out");
        
        XCTAssertNil(sectionInfo.representedObject, "Represented object was not cleared out");
        
        XCTAssertTrue(sectionInfo.countOfRows() == 0, "Contents should have been emptied");
        
        XCTAssertNil(sectionInfo.headerTitle, "Header was not cleared out");
        XCTAssertNil(sectionInfo.footerTitle, "Footer was not cleared out");
        XCTAssertNil(sectionInfo.sectionIndexTitle, "Index title was not cleared out");
    }
    
    func testThatParentSectionInfoIsPopulatedForRowInfo()
    {
        let sectionInfo = tableSectionInfo!
        
        sectionInfo.reset()
        
        let rowInfo = TableRowInfo()
        
        sectionInfo.addRowInfo(rowInfo)
        
        XCTAssertTrue(sectionInfo === rowInfo.parentSectionInfo, "Row info should have a parent section info")
    }
    
    func testCountOfRows()
    {
        XCTAssertEqual(tableSectionInfo?.countOfRows(), 3, "Wrong number of rows")
    }
    
    func testRowInfoAtIndex()
    {
        let sectionInfo = tableSectionInfo!
        
        let row1 = sectionInfo.rowInfoAtIndex(0)
        let row2 = sectionInfo.rowInfoAtIndex(1)
        let row3 = sectionInfo.rowInfoAtIndex(2)
        
        XCTAssertTrue(row1.identifier == "Red", "Wrong row value")
        XCTAssertTrue(row2.identifier == "Green", "Wrong row value")
        XCTAssertTrue(row3.identifier == "Blue", "Wrong row value")
    }
    
    func testAddRowInfo()
    {
        let sectionInfo = tableSectionInfo!

        let rowInfo = TableRowInfo()
        rowInfo.identifier = "Purple"
        
        sectionInfo.addRowInfo(rowInfo)
        
        XCTAssertTrue(sectionInfo.countOfRows() == 4, "Wrong number of rows")
        
        let testRowInfo = sectionInfo.rowInfoAtIndex(3)
        XCTAssertTrue(testRowInfo.identifier == "Purple", "Wrong row value")
    }
    
    func testAddRowInfosFromArray()
    {
        let sectionInfo = tableSectionInfo!
        
        let row1 = TableRowInfo()
        row1.identifier = "Aqua"
        
        let row2 = TableRowInfo()
        row2.identifier = "Pink"
        
        let row3 = TableRowInfo()
        row3.identifier = "Yellow"
        
        let rows: Array = [ row1, row2, row3 ]
        sectionInfo.addRowInfosFromArray(rows)

        XCTAssertTrue(sectionInfo.countOfRows() == 6, "Wrong number of rows")

        let testRow3 = sectionInfo.rowInfoAtIndex(3)
        let testRow4 = sectionInfo.rowInfoAtIndex(4)
        let testRow5 = sectionInfo.rowInfoAtIndex(5)

        XCTAssertTrue(testRow3.identifier == "Aqua", "Wrong row value")
        XCTAssertTrue(testRow4.identifier == "Pink", "Wrong row value")
        XCTAssertTrue(testRow5.identifier == "Yellow", "Wrong row value")
    }
    
    func testAddRowInfosFromSet()
    {
        let sectionInfo = tableSectionInfo!
        
        let row1 = TableRowInfo()
        row1.identifier = "Aqua"
        
        let row2 = TableRowInfo()
        row2.identifier = "Pink"
        
        let row3 = TableRowInfo()
        row3.identifier = "Yellow"
        
        let rows: Set = [ row1, row2, row3 ]
        sectionInfo.addRowInfosFromSet(rows)
        
        XCTAssertTrue(sectionInfo.countOfRows() == 6, "Wrong number of rows")
    }
    
    func testRemoveRowInfoAtIndex()
    {
        let sectionInfo = tableSectionInfo!
        
        sectionInfo.removeRowInfoAtIndex(1)
        
        XCTAssertTrue(sectionInfo.countOfRows() == 2, "Wrong number of rows")
        
        let testRow = sectionInfo.rowInfoAtIndex(1)
        XCTAssertTrue(testRow.identifier == "Blue", "Wrong row value")
    }
    
    func testRemoveRowInfo()
    {
        let sectionInfo = tableSectionInfo!
        
        let rowInfo = sectionInfo.rowInfoAtIndex(1)
        
        sectionInfo.removeRowInfo(rowInfo)
        
        XCTAssertTrue(sectionInfo.countOfRows() == 2, "Wrong number of rows")
        
        let testRow = sectionInfo.rowInfoAtIndex(1)
        XCTAssertTrue(testRow.identifier == "Blue", "Wrong row value")
    }
    
    func testRemoveAllRowInfos()
    {
        let sectionInfo = tableSectionInfo!
        
        sectionInfo.removeAllRowInfos()
        
        XCTAssertTrue(sectionInfo.countOfRows() == 0, "Wrong number of rows")
    }
    
    func testInsertRowInfo()
    {
        let sectionInfo = tableSectionInfo!

        let rowInfo = TableRowInfo()
        rowInfo.identifier = "Purple"

        sectionInfo.insertRowInfo(rowInfo, index: 2)
        
        XCTAssertTrue(sectionInfo.countOfRows() == 4, "Wrong number of rows")
        
        let testRow = sectionInfo.rowInfoAtIndex(2)
        XCTAssertTrue(testRow.identifier == "Purple", "Wrong row value")
    }
    
    func testIndexOfRowInfo()
    {
        let sectionInfo = tableSectionInfo!
        
        let rowInfo = sectionInfo.rowInfoAtIndex(1)
        
        let rowIndex = sectionInfo.indexOfRowInfo(rowInfo)
        
        XCTAssertTrue(rowIndex == 1, "Wrong index")
    }
    
    func testSortUsingDescriptors()
    {
        let sectionInfo = tableSectionInfo!
        
        let alphaSortDescriptor = NSSortDescriptor(key: "identifier", ascending: true, selector: "localizedCaseInsensitiveCompare:")
        
        sectionInfo.sortRowInfos([ alphaSortDescriptor ])

        let testRow1 = sectionInfo.rowInfoAtIndex(0)
        let testRow2 = sectionInfo.rowInfoAtIndex(1)
        let testRow3 = sectionInfo.rowInfoAtIndex(2)
        
        XCTAssertTrue(testRow1.identifier == "Blue", "Wrong row value")
        XCTAssertTrue(testRow2.identifier == "Green", "Wrong row value")
        XCTAssertTrue(testRow3.identifier == "Red", "Wrong row value")
    }
    
    // MARK: - Row Info Scenario Tests
    
    func setUpRowInfoScenario()
    {
        let sectionInfo = tableSectionInfo!
        
        sectionInfo.removeAllRowInfos()
        
        for index in 0..<5
        {
            let rowInfo = TableRowInfo()
            sectionInfo.addRowInfo(rowInfo)
            
            let location = "Row \(index)"
            
            rowInfo.identifier = location + " Identifier"
            rowInfo.text = location + " Text"
            rowInfo.representedObject = location
        }
    }
    
    func testIndexOfIdentifier()
    {
        setUpRowInfoScenario()
        
        let sectionInfo = tableSectionInfo!
        
        XCTAssertEqual(sectionInfo.indexOfRowIdentifier("Row 0 Identifier"), 0, "Wrong index")
        XCTAssertEqual(sectionInfo.indexOfRowIdentifier("Row 1 Identifier"), 1, "Wrong index")
        XCTAssertEqual(sectionInfo.indexOfRowIdentifier("Row 2 Identifier"), 2, "Wrong index")
        XCTAssertEqual(sectionInfo.indexOfRowIdentifier("Row 3 Identifier"), 3, "Wrong index")
        XCTAssertEqual(sectionInfo.indexOfRowIdentifier("Row 4 Identifier"), 4, "Wrong index")
    }
    
    func testIndexOfRepresentedObject()
    {
        setUpRowInfoScenario()
        
        let sectionInfo = tableSectionInfo!
        
        XCTAssertEqual(sectionInfo.indexOfRowRepresentedObject("Row 0"), 0, "Wrong index")
        XCTAssertEqual(sectionInfo.indexOfRowRepresentedObject("Row 1"), 1, "Wrong index")
        XCTAssertEqual(sectionInfo.indexOfRowRepresentedObject("Row 2"), 2, "Wrong index")
        XCTAssertEqual(sectionInfo.indexOfRowRepresentedObject("Row 3"), 3, "Wrong index")
        XCTAssertEqual(sectionInfo.indexOfRowRepresentedObject("Row 4"), 4, "Wrong index")
    }
}
