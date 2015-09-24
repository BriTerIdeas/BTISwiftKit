//
//  NotificationInfo.swift
//  BTISwiftKit
//
//  Created by Brian Slick on 9/23/15.
//  Copyright © 2015 BriTer Ideas LLC. All rights reserved.
//

import Foundation

public enum NotificationInfoLifespan
{
    case ViewControllerLifetime
    case ViewControllerOnScreen
    case Custom
}

public class NotificationInfo: NSObject
{
    // MARK: - Public Properties
    
    public var lifespan: NotificationInfoLifespan { return privateLifespan }
    
    // MARK: - Private Properties
    
    private var privateLifespan: NotificationInfoLifespan
    private var name: String?
    private var object: AnyObject?
    
    // MARK: Standard Listener
    
    private var observer: AnyObject?
    private var selector: Selector?

    // MARK: Block Listener
    
    private var isBlockListener: Bool
    private var block: ((NSNotification) -> Void)?
    private var blockObserver: NSObjectProtocol?
    
    // MARK: - Initialization
    
    public init(observer: AnyObject, selector: Selector, name: String?, object: AnyObject?, lifespan: NotificationInfoLifespan)
    {
        self.observer = observer
        self.selector = selector
        self.name = name
        self.object = object
        self.privateLifespan = lifespan
        
        isBlockListener = false
        block = nil
        blockObserver = nil
        
        super.init()
    }
    
    public init(name: String?, object: AnyObject?, lifespan: NotificationInfoLifespan, usingBlock block: (NSNotification) -> Void) {
        
        observer = nil
        selector = nil
        self.name = name
        self.object = object
        self.privateLifespan = lifespan
        
        isBlockListener = true
        self.block = block
        blockObserver = nil

        super.init()
    }
    
    // MARK: - Misc Methods
    
    public func startListening()
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        if isBlockListener
        {
            let observer = notificationCenter.addObserverForName(name, object: object, queue: nil, usingBlock: block!)
            blockObserver = observer
        }
        else
        {
            notificationCenter.addObserver(observer!, selector: selector!, name: name, object: object)
        }
    }
    
    public func stopListening()
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()

        if isBlockListener
        {
            notificationCenter.removeObserver(blockObserver!)
            
            blockObserver = nil
        }
        else
        {
           notificationCenter.removeObserver(observer!, name: name, object: object)
        }
    }
}