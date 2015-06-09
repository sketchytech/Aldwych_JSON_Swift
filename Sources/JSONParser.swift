//
//  parser.swift
//  JSONParser
//
//  Created by Anthony Levings on 11/03/2015.
//

import Foundation


// receive data
public struct JSONParser {
    public static func parseDictionary(json:NSData, handleBoolValues:Bool = false, restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true) -> JSONDictionary? {
        
        let jsonObject: AnyObject?
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(json, options: [])
        } catch _ {
            jsonObject = nil
        }
        if let js = jsonObject as? Dictionary<String,AnyObject> {

                return JSONDictionary(dict: js, handleBool:handleBoolValues, restrictTypeChanges: restrictTypeChanges, anyValueIsNullable: anyValueIsNullable)
        }
        else {
            return nil
        }
    }
    public static func parseArray(json:NSData, handleBoolValues:Bool = false, restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true) -> JSONArray? {

        let jsonObject: AnyObject?
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(json, options: [])
        } catch _ {
            jsonObject = nil
        }
        if let js = jsonObject as? [AnyObject] {
            
            
            return JSONArray(array: js, handleBool:handleBoolValues, restrictTypeChanges: restrictTypeChanges, anyValueIsNullable: anyValueIsNullable)
            
        }
        else {
            return nil
        }
    }
    
    private static func findBools(data:NSData) -> (boolArray:[String.Index], notBoolArray:[String.Index]) {
        
        // convert data to string
        var string = NSString(data:data, encoding:NSUTF8StringEncoding) as! String
        
        // remove all whitespace
        string = string.stringByReplacingOccurrencesOfString(" ", withString:"")
        
        // find all bool values and place in an Array
        let boolArray = string.getMatches("(:|,|\\[)(true|false)(,|\\]|\\})", options: NSStringCompareOptions.RegularExpressionSearch).map({$0.startIndex})
        
        // find all number values and place in an Array
        let notBoolArray = string.getMatches("(:|,|\\[)(0|1)(,|\\]|\\})", options: NSStringCompareOptions.RegularExpressionSearch).map({$0.startIndex})
        
        print(boolArray)
        print(notBoolArray)
        return (boolArray,notBoolArray)
        
    }
}
