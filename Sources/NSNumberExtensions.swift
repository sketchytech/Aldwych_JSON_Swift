//
//  NSNumberExtensions.swift
//  AldwychBoolTest
//
//  Created by Anthony Levings on 14/05/2015.
//  Copyright (c) 2015 Gylphi. All rights reserved.
//

import Foundation

extension NSNumber {
    func isBoolNumber() -> Bool
    {
        let boolID = CFBooleanGetTypeID() // the type ID of CFBoolean
        let numID = CFGetTypeID(self) // the type ID of num
        return numID == boolID
    }
}