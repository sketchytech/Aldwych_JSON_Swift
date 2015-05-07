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
        
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(json, options: nil, error: nil)
        if let js = jsonObject as? Dictionary<String,AnyObject> {

                return JSONDictionary(dict: js, handleBool:handleBoolValues, restrictTypeChanges: restrictTypeChanges, anyValueIsNullable: anyValueIsNullable)
        }
        else {
            return nil
        }
    }
    public static func parseArray(json:NSData, handleBoolValues:Bool = false, restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true) -> JSONArray? {

        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(json, options: nil, error: nil)
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
        let boolArray = map(string.getMatches("(:|,|\\[)(true|false)(,|\\]|\\})", options: NSStringCompareOptions.RegularExpressionSearch), {$0.startIndex})
        
        // find all number values and place in an Array
        let notBoolArray = map(string.getMatches("(:|,|\\[)(0|1)(,|\\]|\\})", options: NSStringCompareOptions.RegularExpressionSearch), {$0.startIndex})
        
        println(boolArray)
        println(notBoolArray)
        return (boolArray,notBoolArray)
        
    }
}
