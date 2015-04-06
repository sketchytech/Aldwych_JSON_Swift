//
//  StringExtensions.swift
//  SaveFile
//
//  Created by Anthony Levings on 06/04/2015.

//

import Foundation

extension String {
    func nsRangeToRange(range:NSRange) -> Range<String.Index> {
        
        return Range(start: advance(self.startIndex, range.location), end: advance(self.startIndex, range.location+range.length))
        
    }
    mutating func replaceStringsUsingRegularExpression(expression exp:String, withString:String, error err:NSErrorPointer) {
        let strLength = count(self)
        if let regexString = NSRegularExpression(pattern: exp, options: nil, error: err) {
            let st = regexString.stringByReplacingMatchesInString(self, options: nil, range:  NSMakeRange(0, strLength), withTemplate: withString)
            self = st
        }
    }
}
