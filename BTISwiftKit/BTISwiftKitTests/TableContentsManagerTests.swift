//
//  TableContentsManagerTests.swift
//  BTISwiftKit
//
//  Created by Brian Slick on 9/28/15.
//  Copyright © 2015 BriTer Ideas LLC. All rights reserved.
//

import XCTest
import BTISwiftKit

let NUMBER_OF_SECTIONS = 4

class TableContentsManagerTests: XCTestCase
{
    var contentsManager: TableContentsManager? = TableContentsManager()
    
    override func setUp()
    {
        super.setUp()

        let manager = TableContentsManager()
        contentsManager = manager
        
        for sectionIndex in 0..<NUMBER_OF_SECTIONS
        {
            let section = manager.dequeueReusableSectionInfoAndAddToContents()
            section.identifier = "Section \(sectionIndex) Identifier"
            section.representedObject = "Section \(sectionIndex)"
            section.headerTitle = "Section \(sectionIndex) Header"
            section.footerTitle = "Section \(sectionIndex) Footer"
            section.sectionIndexTitle = "\(sectionIndex)"
            
            for rowIndex in 0..<(sectionIndex + 1)
            {
                let rowInfo = manager.dequeueReusableRowInfo()
                section.addRowInfo(rowInfo)
                
                let location = "Section \(sectionIndex) Row \(rowIndex)"
                
                rowInfo.identifier = location + " Identifier"
                rowInfo.text = location + " Text"
                rowInfo.representedObject = location
                rowInfo.rowHeight = Float(rowIndex + 1) * 20.0
            }
        }
    }
    
    override func tearDown()
    {
        super.tearDown()
    }

    func testAddingASectionManually()
    {
        let manager = contentsManager!
        
        manager.reset()
        
        let sectionInfo = manager.dequeueReusableSectionInfo()
        XCTAssertNotNil(sectionInfo, "A section info object should have been created")
        
        XCTAssertEqual(manager.numberOfSections(), 0, "There should be no sections in the manager")
        
        manager.add(sectionInfo)
        
        XCTAssertEqual(manager.numberOfSections(), 1, "There should be one section in the manager")
    }

    func testAddingASectionAutomatically()
    {
        let manager = contentsManager!
        
        manager.reset()

        let _ = manager.dequeueReusableSectionInfoAndAddToContents()
        
        XCTAssertEqual(manager.numberOfSections(), 1, "There should be one section in the manager")
    }

    func testAddingRowsManaually()
    {
        let manager = contentsManager!
        
        manager.reset()
        
        let row1 = manager.dequeueReusableRowInfo()
        let row2 = manager.dequeueReusableRowInfo()
        let row3 = manager.dequeueReusableRowInfo()

        XCTAssertNotNil(row1, "A row info object should have been created")
        XCTAssertNotNil(row2, "A row info object should have been created")
        XCTAssertNotNil(row3, "A row info object should have been created")

        manager.addRowInfo(row1, makeNewSection: false)
        XCTAssertEqual(manager.numberOfSections(), 1, "There should be one section in the manager")
        
        manager.reset()
        
        manager.addRowInfo(row1, makeNewSection: true)
        XCTAssertEqual(manager.numberOfSections(), 1, "There should be one section in the manager")

        manager.addRowInfo(row2, makeNewSection: true)
        XCTAssertEqual(manager.numberOfSections(), 2, "There should be two sections in the manager")

        manager.addRowInfo(row3, makeNewSection: false)
        XCTAssertEqual(manager.numberOfSections(), 2, "There should be two sections in the manager")

        print("\(manager.sections)")
        
        let section1 = manager.sectionInfoAtIndex(0)
        XCTAssertEqual(section1.countOfRows(), 1, "There should be one row in the first section")
        
        let section2 = manager.sectionInfoAtIndex(1)
        XCTAssertEqual(section2.countOfRows(), 2, "There should be two rows in the second section")
    }
    
    func testAddingRowsAutomatically()
    {
        let manager = contentsManager!
        
        manager.reset()
        
        let row1 = manager.dequeueReusableRowInfoAndAddToContents()
        let row2 = manager.dequeueReusableRowInfoAndAddToContents()
        let row3 = manager.dequeueReusableRowInfoAndAddToContents()
        
        XCTAssertNotNil(row1, "A row info object should have been created")
        XCTAssertNotNil(row2, "A row info object should have been created")
        XCTAssertNotNil(row3, "A row info object should have been created")
        
        XCTAssertEqual(manager.numberOfSections(), 1, "There should be one section in the manager")
        XCTAssertEqual(manager.numberOfRowsInSection(0), 3, "There should be 3 rows")
    }
    
    func testNumberOfSections()
    {
        let manager = contentsManager!

        XCTAssertEqual(manager.numberOfSections(), 4, "There should be 4 sections")
    }
    
    func testHeaderTitles()
    {
        let manager = contentsManager!

        XCTAssertEqual("Section 0 Header", manager.headerTitleInSection(0), "Section header is not correct")
        XCTAssertEqual("Section 1 Header", manager.headerTitleInSection(1), "Section header is not correct")
        XCTAssertEqual("Section 2 Header", manager.headerTitleInSection(2), "Section header is not correct")
        XCTAssertEqual("Section 3 Header", manager.headerTitleInSection(3), "Section header is not correct")
    }
    
    func testFooterTitles()
    {
        let manager = contentsManager!
        
        XCTAssertEqual("Section 0 Footer", manager.footerTitleInSection(0), "Section footer is not correct")
        XCTAssertEqual("Section 1 Footer", manager.footerTitleInSection(1), "Section footer is not correct")
        XCTAssertEqual("Section 2 Footer", manager.footerTitleInSection(2), "Section footer is not correct")
        XCTAssertEqual("Section 3 Footer", manager.footerTitleInSection(3), "Section footer is not correct")
    }

    func testNumberOfRowsInSection()
    {
        let manager = contentsManager!
        
        XCTAssertEqual(1, manager.numberOfRowsInSection(0), "There should be 1 row in this section")
        XCTAssertEqual(2, manager.numberOfRowsInSection(1), "There should be 2 rows in this section")
        XCTAssertEqual(3, manager.numberOfRowsInSection(2), "There should be 3 rows in this section")
        XCTAssertEqual(4, manager.numberOfRowsInSection(3), "There should be 4 rows in this section")
    }
    
    func testHeightForRowAtIndexPath()
    {
        let manager = contentsManager!

        let indexPath1 = NSIndexPath(forRow: 0, inSection: 3)
        let indexPath2 = NSIndexPath(forRow: 1, inSection: 3)
        let indexPath3 = NSIndexPath(forRow: 2, inSection: 3)
        let indexPath4 = NSIndexPath(forRow: 3, inSection: 3)
        
        XCTAssertEqual(44.0, manager.heightForRowAtIndexPath(indexPath1), "Row height is not correct")
        XCTAssertEqual(44.0, manager.heightForRowAtIndexPath(indexPath2), "Row height is not correct")
        XCTAssertEqual(60.0, manager.heightForRowAtIndexPath(indexPath3), "Row height is not correct")
        XCTAssertEqual(80.0, manager.heightForRowAtIndexPath(indexPath4), "Row height is not correct")
    }
    
    func testSectionIndexTitles()
    {
        let manager = contentsManager!

        let sectionInfo = manager.sectionInfoAtIndex(2)
        sectionInfo.sectionIndexTitle = nil

        let idealSectionTitles = [ "0", "1", "", "3" ]
        
        XCTAssertEqual(idealSectionTitles, manager.sectionIndexTitles(), "Section titles are not correct")
    }
    
    func testSectionInfoAtIndex()
    {
        let manager = contentsManager!

        let section1 = manager.sectionInfoAtIndex(0)
        let section2 = manager.sectionInfoAtIndex(1)
        let section3 = manager.sectionInfoAtIndex(2)
        let section4 = manager.sectionInfoAtIndex(3)

        XCTAssertEqual("Section 0 Header", section1.headerTitle, "Section header is not correct")
        XCTAssertEqual("Section 1 Header", section2.headerTitle, "Section header is not correct")
        XCTAssertEqual("Section 2 Header", section3.headerTitle, "Section header is not correct")
        XCTAssertEqual("Section 3 Header", section4.headerTitle, "Section header is not correct")
    }
    
    func testSectionInfoForIdentifier()
    {
        let manager = contentsManager!

        let identiferSection = manager.sectionInfoForIdentifier("Section 2 Identifier")
        
        XCTAssertEqual("Section 2 Header", identiferSection?.headerTitle, "Section header is not correct")
    }
    
    func testRepresentedSectionObject()
    {
        let manager = contentsManager!

        let section1 = manager.sectionInfoAtIndex(0)
        let section2 = manager.sectionInfoAtIndex(1)
        let section3 = manager.sectionInfoAtIndex(2)
        let section4 = manager.sectionInfoAtIndex(3)
        
        let representedObject1 = section1.representedObject as! String
        let representedObject2 = section2.representedObject as! String
        let representedObject3 = section3.representedObject as! String
        let representedObject4 = section4.representedObject as! String
        
        XCTAssertEqual("Section 0", representedObject1, "Represented object is not correct")
        XCTAssertEqual("Section 1", representedObject2, "Represented object is not correct")
        XCTAssertEqual("Section 2", representedObject3, "Represented object is not correct")
        XCTAssertEqual("Section 3", representedObject4, "Represented object is not correct")
    }

    func testRowInfoAtIndexPath()
    {
        let manager = contentsManager!

        let indexPath1 = NSIndexPath(forRow: 0, inSection: 0)
        let indexPath2 = NSIndexPath(forRow: 2, inSection: 2)
        
        let rowInfo1 = manager.rowInfoAtIndexPath(indexPath1)
        let rowInfo2 = manager.rowInfoAtIndexPath(indexPath2)
        
        XCTAssertEqual("Section 0 Row 0 Text", rowInfo1.text, "Row info text is not correct")
        XCTAssertEqual("Section 2 Row 2 Text", rowInfo2.text, "Row info text is not correct")
    }
    
    func testRepresentedObjectAtIndexPath()
    {
        let manager = contentsManager!

        let indexPath1 = NSIndexPath(forRow: 0, inSection: 0)
        let indexPath2 = NSIndexPath(forRow: 2, inSection: 2)
        
        let rowInfo1 = manager.rowInfoAtIndexPath(indexPath1)
        let rowInfo2 = manager.rowInfoAtIndexPath(indexPath2)
        
        let representedObject1 = rowInfo1.representedObject as! String
        let representedObject2 = rowInfo2.representedObject as! String

        XCTAssertEqual("Section 0 Row 0", representedObject1, "Represented object is not correct")
        XCTAssertEqual("Section 2 Row 2", representedObject2, "Represented object is not correct")
    }
    
    func testIndexOfSectionInfo()
    {
        let manager = contentsManager!

        let targetIndex = 2
        
        let sectionInfo = manager.sections[targetIndex]
        
        XCTAssertEqual(targetIndex, manager.indexOfSectionInfo(sectionInfo), "Wrong section index")
    }
    
    func testIndexOfRepresentedSectionObject()
    {
        let manager = contentsManager!
        
        let targetIndex = 2

        let representedObject = "Section 2"
        
        XCTAssertEqual(targetIndex, manager.indexOfRepresentedSectionObject(representedObject), "Wrong section index")
    }
    
    func testIndexOfSectionIdentifier()
    {
        let manager = contentsManager!
        
        let targetIndex = 2
        
        let sectionIdentifier = "Section 2 Identifier"
        
        XCTAssertEqual(targetIndex, manager.indexOfSectionIdentifier(sectionIdentifier), "Wrong section index")
    }
    
    func testIndexPathOfRowInfo()
    {
        let manager = contentsManager!

        let targetIndexPath = NSIndexPath(forRow: 2, inSection: 2)
        
        let sectionInfo = manager.sectionInfoAtIndex(targetIndexPath.section)
        let rowInfo = sectionInfo.rowInfoAtIndex(targetIndexPath.row)
        
        XCTAssertEqual(targetIndexPath, manager.indexPathOfRowInfo(rowInfo), "Wrong index path")
    }
    
    func testIndexPathOfRepresentedRowObject()
    {
        let manager = contentsManager!
        
        let targetIndexPath = NSIndexPath(forRow: 2, inSection: 2)

        let representedObject = "Section 2 Row 2"

        XCTAssertEqual(targetIndexPath, manager.indexPathOfRepresentedRowObject(representedObject), "Wrong index path")
    }
    
    func testIndexPathOfRowIdentifier()
    {
        let manager = contentsManager!
        
        let targetIndexPath = NSIndexPath(forRow: 2, inSection: 2)
        
        let identifier = "Section 2 Row 2 Identifier"
        
        XCTAssertEqual(targetIndexPath, manager.indexPathOfRowIdentifier(identifier), "Wrong index path")
    }
    
    func testAllSectionIndexes()
    {
        let manager = contentsManager!
        
        let targetIndexSet = NSIndexSet(indexesInRange: NSMakeRange(0, NUMBER_OF_SECTIONS))
        
        XCTAssertEqual(targetIndexSet, manager.allSectionIndexes(), "Wrong indexes")
    }
    
    func testAllIndexPaths()
    {
        let manager = contentsManager!

        var targetIndexPaths = [NSIndexPath]()
        
        for sectionIndex in 0..<NUMBER_OF_SECTIONS
        {
            for rowIndex in 0..<(sectionIndex + 1)
            {
                let indexPath = NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
                targetIndexPaths.append(indexPath)
            }
        }
        
        XCTAssertEqual(targetIndexPaths, manager.allIndexPaths(), "Wrong index paths")
    }
}
