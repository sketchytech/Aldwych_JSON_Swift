//
//  parser.swift
//  JSONParser
//
//  Created by Anthony Levings on 11/03/2015.
//

import Foundation


// receive data
public struct JSONParser {
    public static func parseDictionary(json:NSData) -> JSONDictionary? {
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(json, options: nil, error: nil)
        if let js = jsonObject as? Dictionary<String,AnyObject> {
            return JSONDictionary(dict: js)
        }
        else {
            return nil
        }
    }
    public static func parseArray(json:NSData) -> JSONArray? {
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(json, options: nil, error: nil)
        if let js = jsonObject as? [AnyObject] {
            return JSONArray(array: js)
        }
        else {
            return nil
        }
    }
}
