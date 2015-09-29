//
//  TableSectionInfo.swift
//  BTISwiftKit
//
//  Created by Brian Slick on 9/24/15.
//  Copyright © 2015 BriTer Ideas LLC. All rights reserved.
//

import Foundation
import UIKit

public class TableSectionInfo: NSObject
{
    // MARK: - Public Properties
    
    public var identifier: String?
    public var representedObject: AnyObject?
    public var headerTitle: String?
    public var footerTitle: String?
    public var sectionIndexTitle: String?
    public var rows: [TableRowInfo] { let objects = privateRows; return objects }
    
    // MARK: - Private Properties
    
    private lazy var UUIDString: String = NSUUID().UUIDString
    private lazy var privateRows: [TableRowInfo] = []
    
    // MARK: - NSObject Methods
    
    public override var hash:Int
        {
        get {
            return UUIDString.hash
        }
    }
    
    public override func isEqual(object: AnyObject?) -> Bool
    {
        var isEqual = false
        
        if let otherSectionInfo = object as? TableSectionInfo
        {
            isEqual = UUIDString == otherSectionInfo.UUIDString
        }
        
        return isEqual
    }

    // MARK: - Misc Methods
    
    public func reset()
    {
        identifier = nil
        representedObject = nil
        headerTitle = nil
        footerTitle = nil
        sectionIndexTitle = nil
        
        privateRows.removeAll()
    }

    // MARK: - Rows Accessor Methods
    
    public func countOfRows() -> Int
    {
        return privateRows.count
    }
    
    public func rowInfoAtIndex(index: Int) -> TableRowInfo
    {
        return privateRows[index]
    }
    
    public func addRowInfo(rowInfo: TableRowInfo)
    {
        privateRows.append(rowInfo)
        
        rowInfo.parentSectionInfo = self
    }
    
    public func addRowInfosFromArray(rowInfos: Array<TableRowInfo>)
    {
        for rowInfo in rowInfos
        {
            addRowInfo(rowInfo)
        }
    }
    
    public func addRowInfosFromSet(rowInfos: Set<TableRowInfo>)
    {
        for rowInfo in rowInfos
        {
            addRowInfo(rowInfo)
        }
    }
    
    public func removeRowInfo(rowInfo: TableRowInfo)
    {
        rowInfo.parentSectionInfo = nil
        
        privateRows.removeObject(rowInfo)
    }
    
    public func removeRowInfoAtIndex(index: Int)
    {
        let rowInfo = privateRows[index]
        
        removeRowInfo(rowInfo)
    }
    
    public func removeAllRowInfos()
    {
        let objects = privateRows
        
        for rowInfo in objects
        {
            removeRowInfo(rowInfo)
        }
    }
    
    public func insertRowInfo(rowInfo: TableRowInfo, index: Int)
    {
        privateRows.insert(rowInfo, atIndex: index)
        
        rowInfo.parentSectionInfo = self
    }
    
    public func indexOfRowInfo(rowInfo: TableRowInfo) -> Int?
    {
        return privateRows.indexOf(rowInfo)
    }
    
    // TODO: Equivalent of enumeratorOfRows
    
    public func sortRowInfos(descriptors: [NSSortDescriptor])
    {
        let originalRows = privateRows as NSArray
        
        let sortedRows = originalRows.sortedArrayUsingDescriptors(descriptors)
        
        privateRows = sortedRows as! Array<TableRowInfo>
    }
    
    // MARK: - BTITableContentsManager Support Methods
    
    public func indexOfRowIdentifier(identifier: String) -> Int?
    {
        var indexToReturn: Int?
        var index = 0
        
        for rowInfo in privateRows
        {
            if let rowInfoIdentifier = rowInfo.identifier
            {
                if rowInfoIdentifier == identifier
                {
                    indexToReturn = index
                    break
                }
            }
            index++
        }
        return indexToReturn
    }
    
    public func indexOfRowRepresentedObject(representedObject: AnyObject) -> Int?
    {
        var indexToReturn: Int?
        var index = 0
        
        for rowInfo in privateRows
        {
            if let rowObject = rowInfo.representedObject
            {
                let leftSide = rowObject as! NSObject
                let rightSide = representedObject as! NSObject

                if leftSide == rightSide
                {
                    indexToReturn = index
                    break
                }
            }
            index++
        }
        return indexToReturn
    }
    
}