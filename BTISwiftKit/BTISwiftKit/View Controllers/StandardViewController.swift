//
//  StandardViewController.swift
//  BTISwiftKit
//
//  Created by Brian Slick on 9/24/15.
//  Copyright © 2015 BriTer Ideas LLC. All rights reserved.
//

import Foundation
import UIKit

public class StandardViewController: UIViewController
{
    // MARK: - Public Properties
    
    
    // MARK: - Private Properties
    
    private lazy var notificationInfos = Set<NotificationInfo>()
    
    // MARK: - Initialization
    
    public convenience init()
    {
        self.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.populateNotificationInfos()
        self.startListeningForNotifications(lifespan: .ViewControllerLifetime)
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        self.populateNotificationInfos()
        self.startListeningForNotifications(lifespan: .ViewControllerLifetime)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.populateNotificationInfos()
        self.startListeningForNotifications(lifespan: .ViewControllerLifetime)
    }
    
    // MARK: - UIViewController Overrides
    
    public override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.startListeningForNotifications(lifespan: .ViewControllerOnScreen)
    }
    
    public override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.stopListeningForNotifications(lifespan: .ViewControllerOnScreen)
    }
    
    // MARK: - Misc Methods
    
    public func populateContents()
    {
        // Deliberately empty. Subclasses should override and call super
    }
    
    // MARK: - NotificationInfo Support Methods
    
    public func populateNotificationInfos()
    {
        // Subclasses should override and call super first
        
        for notificationInfo in notificationInfos
        {
            notificationInfo.stopListening()
        }
        
        notificationInfos.removeAll()
    }
    
    func startListeningForNotifications(lifespan lifespan: NotificationInfoLifespan)
    {
        for notificationInfo in notificationInfos
        {
            if notificationInfo.lifespan == lifespan
            {
                notificationInfo.startListening()
            }
        }
    }
    
    func stopListeningForNotifications(lifespan lifespan: NotificationInfoLifespan)
    {
        for notificationInfo in notificationInfos
        {
            if notificationInfo.lifespan == lifespan
            {
                notificationInfo.stopListening()
            }
        }
    }
    
    func stopListeningForAllNotifications()
    {
        for notificationInfo in notificationInfos
        {
            notificationInfo.stopListening()
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public func addNotificationInfo(notificationInfo: NotificationInfo)
    {
        notificationInfos.insert(notificationInfo)
    }
    
    // MARK: Lifetime convenience methods
    
    public func addLifetimeNotificationInfo(name name: String, selector: Selector, object: AnyObject?)
    {
        let notificationInfo = NotificationInfo(observer: self, selector: selector, name: name, object: object, lifespan: .ViewControllerLifetime)
        
        addNotificationInfo(notificationInfo)
    }
    
    public func addLifetimeNotificationInfo(name name: String, selector: Selector)
    {
        addLifetimeNotificationInfo(name: name, selector: selector, object: nil)
    }
    
    public func addLifetimeNotificationInfo(name name: String, object: AnyObject?, usingBlock: (NSNotification) -> Void)
    {
        let notificationInfo = NotificationInfo(name: name, object: object, lifespan: .ViewControllerLifetime, usingBlock: usingBlock)
        
        addNotificationInfo(notificationInfo)
    }
    
    // MARK: Visible convenience methods
    
    public func addVisibleNotificationInfo(name name: String, selector: Selector, object: AnyObject?)
    {
        let notificationInfo = NotificationInfo(observer: self, selector: selector, name: name, object: object, lifespan: .ViewControllerOnScreen)
        
        addNotificationInfo(notificationInfo)
    }
    
    public func addVisibleNotificationInfo(name name: String, selector: Selector)
    {
        addVisibleNotificationInfo(name: name, selector: selector, object: nil)
    }
    
    public func addVisibleNotificationInfo(name name: String, object: AnyObject?, usingBlock: (NSNotification) -> Void)
    {
        let notificationInfo = NotificationInfo(name: name, object: object, lifespan: .ViewControllerOnScreen, usingBlock: usingBlock)
        
        addNotificationInfo(notificationInfo)
    }
 
    // MARK: - Deinitialization
    
    deinit
    {
        stopListeningForAllNotifications()
    }
    
}