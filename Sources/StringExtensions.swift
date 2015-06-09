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
    public mutating func replaceStringsUsingRegularExpression(expression exp:String, withString:String, options opt:NSMatchingOptions = .ReportCompletion, error err:NSErrorPointer) {
        let strLength = self.characters.count
        do {
            let regexString = try NSRegularExpression(pattern: exp, options: [])
            let st = regexString.stringByReplacingMatchesInString(self, options: opt, range:  NSMakeRange(0, strLength), withTemplate: withString)
            self = st
        } catch let error as NSError {
            err.memory = error
        }
    }
    
    
    public func getMatches(regex: String, options: NSStringCompareOptions?) -> [Range<String.Index>] {
            var arr = [Range<String.Index>]()
            var rang = Range(start: self.startIndex, end: self.endIndex)
            var foundRange:Range<String.Index>?
            
            repeat
            {
                foundRange = self.rangeOfString(regex, options: (options ?? nil)!, range: rang, locale: nil)
                
                if let a = foundRange {
                    arr.append(a)
                    rang.startIndex = foundRange!.endIndex
                }
            }
                while foundRange != nil
            return  arr
        }
    
}
