//
//  TableRowInfo.swift
//  BTISwiftKit
//
//  Created by Brian Slick on 9/24/15.
//  Copyright © 2015 BriTer Ideas LLC. All rights reserved.
//

import Foundation
import UIKit

public class TableRowInfo: NSObject
{
    // MARK: - Public Properties
    
    public var identifier: String?
    public var representedObject: AnyObject?
    public weak var parentSectionInfo: TableSectionInfo?
    
    // MARK: Table Cell Display Properties
    
    public var text: String?
    public var detailText: String?
    public var cellAccessoryType: UITableViewCellAccessoryType? = .None
    public var rowHeight: Float?
    
    // MARK: Image Support Properties
    
    public var image: UIImage?
    public var imageName: String?
    public var imageFileURL: NSURL?
    
    // MARK: Table Cell Action Properties
    
    public var rowSelectionBlock: (Void -> Void)?
    public var rowAccessorySelectionBlock: (Void -> Void)?
    
    // MARK: - Private Properties
    
    private lazy var UUIDString: String = NSUUID().UUIDString
    
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
        
        if let otherRowInfo = object as? TableRowInfo
        {
            isEqual = UUIDString == otherRowInfo.UUIDString
        }
        
        return isEqual
    }
    
    // MARK: - Misc Methods
    
    public func reset()
    {
        identifier = nil
        representedObject = nil
        parentSectionInfo = nil
        
        text = nil
        detailText = nil
        cellAccessoryType = .None
        rowHeight = 0.0
        
        image = nil
        imageName = nil
        imageFileURL = nil
        
        rowSelectionBlock = nil
        rowAccessorySelectionBlock = nil
    }
    
    public func populateCell(cell: UITableViewCell)
    {
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = detailText
        cell.accessoryType = cellAccessoryType!
        
        var imageToUse: UIImage?
        
        if let anImage = image
        {
            imageToUse = anImage
        }
        else if let anImageName = imageName
        {
            imageToUse = UIImage(named: anImageName)
        }
        else if let anImageURL = imageFileURL
        {
            imageToUse = UIImage(contentsOfFile: anImageURL.path!)
        }
        
        cell.imageView?.image = imageToUse
    }
    
    public func safelyPerformRowSelectionBlock()
    {
        if let block = rowSelectionBlock
        {
            block()
        }
    }
    
    public func safelyPerformRowAccessorySelectionBlock()
    {
        if let block = rowAccessorySelectionBlock
        {
            block()
        }
    }
    
}