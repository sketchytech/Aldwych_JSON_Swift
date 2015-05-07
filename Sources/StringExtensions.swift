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
    public mutating func replaceStringsUsingRegularExpression(expression exp:String, withString:String, options opt:NSMatchingOptions = nil, error err:NSErrorPointer) {
        let strLength = count(self)
        if let regexString = NSRegularExpression(pattern: exp, options: nil, error: err) {
            let st = regexString.stringByReplacingMatchesInString(self, options: opt, range:  NSMakeRange(0, strLength), withTemplate: withString)
            self = st
        }
    }
    
    
    public func getMatches(regex: String, options: NSStringCompareOptions?) -> [Range<String.Index>] {
            var arr = [Range<String.Index>]()
            var rang = Range(start: self.startIndex, end: self.endIndex)
            var foundRange:Range<String.Index>?
            
            do
            {
                foundRange = self.rangeOfString(regex, options: options ?? nil, range: rang, locale: nil)
                
                if let a = foundRange {
                    arr.append(a)
                    rang.startIndex = foundRange!.endIndex
                }
            }
                while foundRange != nil
            return  arr
        }
    
}
