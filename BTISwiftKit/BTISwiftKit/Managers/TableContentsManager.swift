//
//  TableContentsManager.swift
//  BTISwiftKit
//
//  Created by Brian Slick on 9/24/15.
//  Copyright © 2015 BriTer Ideas LLC. All rights reserved.
//

import Foundation
import UIKit

public class TableContentsManager: NSObject
{
    // MARK: - Public Properties
    
    public var sections: [TableSectionInfo] { let sections = privateSections; return sections }
    public var minimumRowHeight = 44.0
    
    // MARK: - Private Properties
    
    private lazy var privateSections = [TableSectionInfo]()
    private lazy var sectionInfoCache = Set<TableSectionInfo>()
    private lazy var rowInfoCache = Set<TableRowInfo>()
    
    // MARK: - Initialization
    
    public override init()
    {
        super.init()

        NSNotificationCenter().addObserver(self, selector: "didReceiveMemoryWarning:", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    // MARK: - Notification Handlers
    
    func didReceiveMemoryWarning(notification: NSNotification)
    {
        sectionInfoCache.removeAll()
        rowInfoCache.removeAll()
    }
    
    // MARK: - Primary Management Methods
    
    public func reset()
    {
        for tableSectionInfo in privateSections
        {
            enqueueSectionInfo(tableSectionInfo)
        }
        
        privateSections.removeAll()
        
        minimumRowHeight = 44.0
    }
    
    // MARK: - TableSectionInfo Methods
    
//    public func dequeueReusableSectionInfo() -> TableSectionInfo
//    {
//        var cache = sectionInfoCache
//        var sectionInfoToReturn: TableSectionInfo
//
//        if let sectionInfo = cache.first
//        {
//            print("sectionInfo: \(sectionInfo)")
//            print("sectionInfoCache before: \(sectionInfoCache)")
//            sectionInfoToReturn = sectionInfo
//            cache.remove(sectionInfo)
//            print("sectionInfoCache after: \(sectionInfoCache)")
//        }
//        else
//        {
//            sectionInfoToReturn = TableSectionInfo()
//        }
//        
//        return sectionInfoToReturn
//    }
    
    public func dequeueReusableSectionInfo() -> TableSectionInfo
    {
        var sectionInfoToReturn: TableSectionInfo
        
        if let sectionInfo = sectionInfoCache.first
        {
            print("sectionInfo: \(sectionInfo)")
            print("sectionInfoCache before: \(sectionInfoCache)")
            
            sectionInfoToReturn = sectionInfo
            sectionInfoCache.remove(sectionInfo)
            
            print("sectionInfoCache after: \(sectionInfoCache)")
        }
        else
        {
            sectionInfoToReturn = TableSectionInfo()
        }
        
        return sectionInfoToReturn
    }

    public func dequeueReusableSectionInfoAndAddToContents() -> TableSectionInfo
    {
        let sectionInfo = dequeueReusableSectionInfo()
        
        add(sectionInfo)
        
        return sectionInfo
    }
    
    public func add(sectionInfo: TableSectionInfo)
    {
        privateSections.append(sectionInfo)
    }
    
    func enqueueSectionInfo(sectionInfo: TableSectionInfo)
    {
        sectionInfoCache.insert(sectionInfo)
        privateSections.removeObject(sectionInfo)
        
        let rowInfos = sectionInfo.rows
        
        for rowInfo in rowInfos
        {
            enqueueRowInfo(rowInfo)
        }
        
        sectionInfo.reset()
    }
    
    // MARK: - TableRowInfo Methods
    
    public func dequeueReusableRowInfo() -> TableRowInfo
    {
        var rowInfoToReturn: TableRowInfo
        
        if let rowInfo = rowInfoCache.first
        {
            rowInfoToReturn = rowInfo
            rowInfoCache.remove(rowInfo)
        }
        else
        {
            rowInfoToReturn = TableRowInfo()
        }
        
        return rowInfoToReturn
    }
    
    public func dequeueReusableRowInfoAndAddToContents() -> TableRowInfo
    {
        let rowInfo = dequeueReusableRowInfo()
        
        var sectionInfo: TableSectionInfo
        
        if privateSections.count > 0
        {
            sectionInfo = privateSections.last!
        }
        else
        {
            sectionInfo = dequeueReusableSectionInfoAndAddToContents()
        }
        
        sectionInfo.addRowInfo(rowInfo)
        
        return rowInfo
    }
    
    public func addRowInfo(rowInfo: TableRowInfo, makeNewSection: Bool)
    {
        if (makeNewSection)
        {
            let sectionInfo = dequeueReusableSectionInfoAndAddToContents()
            
            sectionInfo.addRowInfo(rowInfo)
        }
        else
        {
            var sectionInfo: TableSectionInfo
            
            if privateSections.count > 0
            {
                sectionInfo = privateSections.last!
            }
            else
            {
                sectionInfo = dequeueReusableSectionInfoAndAddToContents()
            }
            
            sectionInfo.addRowInfo(rowInfo)
        }
        
        if rowInfoCache.contains(rowInfo)
        {
            rowInfoCache.remove(rowInfo)
        }
    }
    
    func enqueueRowInfo(rowInfo: TableRowInfo)
    {
        rowInfoCache.insert(rowInfo)
        
        rowInfo.reset()
    }
    
    // MARK: - UITableView Support Methods
    
    public func numberOfSections() -> Int
    {
        return privateSections.count
    }
    
    public func headerTitleInSection(index: Int) -> String?
    {
        let sectionInfo = sectionInfoAtIndex(index)
        
        return sectionInfo.headerTitle
    }
    
    public func footerTitleInSection(index: Int) -> String?
    {
        let sectionInfo = sectionInfoAtIndex(index)
        
        return sectionInfo.footerTitle
    }
    
    public func numberOfRowsInSection(index: Int) -> Int
    {
        let sectionInfo = sectionInfoAtIndex(index)
        
        return sectionInfo.countOfRows()
    }
    
    public func heightForRowAtIndexPath(indexPath: NSIndexPath) -> Float
    {
        let rowInfo = rowInfoAtIndexPath(indexPath)
            
        return max(Float(rowInfo.rowHeight!), Float(minimumRowHeight))
    }
    
    public func sectionIndexTitles() -> [String]
    {
        var titles: [String] = []
        
        for sectionInfo in privateSections
        {
            if let sectionIndexTitle = sectionInfo.sectionIndexTitle
            {
                titles.append(sectionIndexTitle)
            }
            else
            {
                titles.append("")
            }
        }
        
        return titles
    }
    
    // MARK: - Content Retrieval Methods
    
    public func sectionInfoAtIndex(index: Int) -> TableSectionInfo
    {
        return privateSections[index]
    }
    
    public func sectionInfoForIdentifier(identifier: String) -> TableSectionInfo?
    {
        var sectionInfoToReturn: TableSectionInfo? = nil
        
        for sectionInfo in privateSections
        {
            if sectionInfo.identifier == identifier
            {
                sectionInfoToReturn = sectionInfo
                break
            }
        }
        
        return sectionInfoToReturn
    }
    
    public func representedObjectAtSectionIndex(index: Int) -> AnyObject?
    {
        let sectionInfo = privateSections[index]
        
        return sectionInfo.representedObject
    }
    
    public func rowInfoAtIndexPath(indexPath: NSIndexPath) -> TableRowInfo
    {
        let sectionInfo = privateSections[indexPath.section]
        let rowInfo = sectionInfo.rowInfoAtIndex(indexPath.row)
        
        return rowInfo
    }
    
    public func rowInfoForIdentifier(identifier: String) -> TableRowInfo?
    {
        var rowInfoToReturn: TableRowInfo? = nil
        
        sectionLoop: for sectionInfo in privateSections
        {
            rowLoop: for rowInfo in sectionInfo.rows
            {
                if rowInfo.identifier == identifier
                {
                    rowInfoToReturn = rowInfo
                    break sectionLoop
                }
            }
        }
        
        return rowInfoToReturn
    }
    
    public func representedObjectAtIndexPath(indexPath: NSIndexPath) -> AnyObject?
    {
        let rowInfo = rowInfoAtIndexPath(indexPath)
        
        return rowInfo.representedObject
    }
    
    // MARK: - Interrogation Methods
    
    public func indexOfSectionInfo(sectionInfo: TableSectionInfo) -> Int?
    {
        return privateSections.indexOf(sectionInfo)
    }
    
    public func indexOfRepresentedSectionObject(representedObject: AnyObject) -> Int?
    {
        var indexToReturn: Int?
        var index = 0
        
        for sectionInfo in privateSections
        {
            if let sectionObject = sectionInfo.representedObject
            {
                let leftSide = sectionObject as! NSObject
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
    
    public func indexOfSectionIdentifier(identifier: String) -> Int?
    {
        var indexToReturn: Int?
        
        var index = -1
        
        for sectionInfo in privateSections
        {
            index++
            
            if let sectionIdentifier = sectionInfo.identifier
            {
                if identifier == sectionIdentifier
                {
                    indexToReturn = index
                    break
                }
            }
        }
        
        return indexToReturn
    }
    
    public func indexPathOfRowInfo(rowInfo: TableRowInfo) -> NSIndexPath?
    {
        var section = 0
        var row: Int?
        
        for sectionInfo in privateSections
        {
            if let searchRow = sectionInfo.indexOfRowInfo(rowInfo)
            {
                row = searchRow
                break;
            }
            section++
        }
        
        var indexPathToReturn: NSIndexPath? = nil
        
        if let foundRow = row
        {
            indexPathToReturn = NSIndexPath(forRow: foundRow, inSection: section)
        }
        
        return indexPathToReturn
    }
    
    public func indexPathOfRepresentedRowObject(representedObject: AnyObject) -> NSIndexPath?
    {
        var section = 0
        var row: Int?
        
        for sectionInfo in privateSections
        {
            if let searchRow = sectionInfo.indexOfRowRepresentedObject(representedObject)
            {
                row = searchRow
                break;
            }
            section++
        }
        
        var indexPathToReturn: NSIndexPath? = nil
        
        if let foundRow = row
        {
            indexPathToReturn = NSIndexPath(forRow: foundRow, inSection: section)
        }
        
        return indexPathToReturn
    }
    
    public func indexPathOfRowIdentifier(identifier: String) -> NSIndexPath?
    {
        var section = 0
        var row: Int?
        
        for sectionInfo in privateSections
        {
            if let searchRow = sectionInfo.indexOfRowIdentifier(identifier)
            {
                row = searchRow
                break;
            }
            section++
        }
        
        var indexPathToReturn: NSIndexPath? = nil
        
        if let foundRow = row
        {
            indexPathToReturn = NSIndexPath(forRow: foundRow, inSection: section)
        }
        
        return indexPathToReturn
    }
    
    public func allSectionIndexes() -> NSIndexSet
    {
        return NSIndexSet(indexesInRange: NSMakeRange(0, privateSections.count))
    }
    
    public func allIndexPaths() -> [NSIndexPath]
    {
        var indexPaths: [NSIndexPath] = []
        
        var section: Int
        for section = 0; section < privateSections.count; section++
        {
            let sectionInfo = sectionInfoAtIndex(section)
            
            var row: Int
            for row = 0; row < sectionInfo.countOfRows(); row++
            {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                indexPaths.append(indexPath)
            }
        }
        
        return indexPaths
    }
    
}
