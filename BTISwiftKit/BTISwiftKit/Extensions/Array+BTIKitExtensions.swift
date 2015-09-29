//
//  Array+BTIKitExtensions.swift
//  BTISwiftKit
//
//  Created by Brian Slick on 9/24/15.
//  Copyright © 2015 BriTer Ideas LLC. All rights reserved.
//

import Foundation

// http://stackoverflow.com/a/30724543

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}