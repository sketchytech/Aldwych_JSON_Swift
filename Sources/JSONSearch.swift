//
//  JSONSearch.swift
//  SaveFile
//
//  Created by Anthony Levings on 06/04/2015.

//

import Foundation


public func replaceStringUsingRegularExpressionInJSONArray(expression exp:String, inout arr:JSONArray, withString string: String, options opt:NSMatchingOptions = []) {
    
    // make sure we can make type changes everywhere
    arr.restrictTypeChanges = false
    arr.inheritRestrictions = true
    var error:NSError?
    for a in arr.enumerate() {
        if let _ = a.element.jsonArr {
            replaceStringUsingRegularExpressionInJSONArray(expression: exp, arr: &arr[a.index]!, withString:string)
        }
        else if let str = a.element.str {
            var s = str
            s.replaceStringsUsingRegularExpression(expression: exp, withString:string, error: &error)
            arr[a.index] = s
        }
        else if let _ = a.element.jsonDict {
            replaceStringUsingRegularExpressionInJSONDictionary(exp, dict: &arr[a.index]!, withString: string,options:opt)
        }
        
    }
}
public func replaceStringUsingRegularExpressionInJSONDictionary(exp:String, inout dict:JSONDictionary, withString string:String, options opt:NSMatchingOptions = []) {
    
    // make sure we can make type changes everywhere
    dict.restrictTypeChanges = false
    dict.inheritRestrictions = true
    
    for (k,v) in dict {
        if let st = v?.str {
            var s = st
            s.replaceStringsUsingRegularExpression(expression: exp, withString: string, options:opt, error: nil)
            dict[k] = s
        }
        
        else if let _ = v?.jsonDict {

        replaceStringUsingRegularExpressionInJSONDictionary(exp, dict: &dict[k]!, withString: string)
        }
        else if let _ = v?.jsonArr {
            replaceStringUsingRegularExpressionInJSONArray(expression: exp, arr: &dict[k]!, withString:string, options:opt)

        }


    }
    
 
    
    
}

public func replaceStringWithStringInJSONArray(string:String, inout arr:JSONArray, withString: String, options opt:NSMatchingOptions = []) {
    
    // make sure we can make type changes everywhere
    arr.restrictTypeChanges = false
    arr.inheritRestrictions = true
    
    for a in arr.enumerate() {
        if let _ = a.element.jsonArr {
        
            replaceStringUsingRegularExpressionInJSONArray(expression: string, arr: &arr[a.index]!, withString:withString)
        }
        else if let str = a.element.str {
            let s = str
            s.stringByReplacingOccurrencesOfString(str, withString: withString, options: [], range: nil)
  
            arr[a.index] = s
        }
        else if let _ = a.element.jsonDict {
            replaceStringUsingRegularExpressionInJSONDictionary(string, dict: &arr[a.index]!, withString: withString,options:opt)
        }
        
    }
}
public func replaceStringWithStringInJSONDictionary(string:String, inout dict:JSONDictionary, withString:String, options opt:NSMatchingOptions = []) {
    
    // make sure we can make type changes everywhere
    dict.restrictTypeChanges = false
    dict.inheritRestrictions = true
    
    for (k,v) in dict {
        if let st = v?.str {
            var s = st
            s.replaceStringsUsingRegularExpression(expression: string, withString: withString, options:opt, error: nil)
            dict[k] = s
        }
            
        else if let _ = v?.jsonDict {
            
            replaceStringUsingRegularExpressionInJSONDictionary(string, dict: &dict[k]!, withString: withString)
        }
        else if let _ = v?.jsonArr {
            replaceStringUsingRegularExpressionInJSONArray(expression: string, arr: &dict[k]!, withString:withString, options:opt)
            
        }
        
        
    }
    
    
    
    
}

public func replaceValue(key:String, inout dict:JSONDictionary, array arra:JSONArray) {
    
    // make sure we can make type changes everywhere
    dict.restrictTypeChanges = false
    dict.inheritRestrictions = true
    
    if dict.keys.contains(key) {
        dict[key] = arra
    }
        
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in arr.enumerate() {
                    if let _ = a.element.jsonDict {
                        replaceValue(key, dict: &dict[k]![a.index]!,array: arra)
                    }
                }
            }
        }
    }
    
      /*
// needs testing and repeating across
    else if let dK = dict.keysWithDictionaryValues {
        println("dictionary keys")
        for k in dK {
            replaceValue(key, &dict[k]!,array: arra)
        }
    }*/
    
    
}

func replaceValue(key:String, inout dict:JSONDictionary, dictionary dic:JSONDictionary) {
    
    // make sure we can make type changes everywhere
    dict.restrictTypeChanges = false
    dict.inheritRestrictions = true
    
    if dict.keys.contains(key) {
        dict[key] = dic
    }
        
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in arr.enumerate() {
                    if let _ = a.element.jsonDict {
                        replaceValue(key, dict: &dict[k]![a.index]!,dictionary: dic)
                    }
                }
            }
        }
    }
    
    
}

func replaceValue(key:String, inout dict:JSONDictionary, string str:String) {
    
    // make sure we can make type changes everywhere
    dict.restrictTypeChanges = false
    dict.inheritRestrictions = true
    
    if dict.keys.contains(key) {
        dict[key] = str
    }
 /*
    // needs testing and repeating across
    else if let dK = dict.keysWithDictionaryValues {
        println("dictionary keys")
        for k in dK {
            replaceValue(key, &dict[k]!,string:str)
        }
    }*/
        
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in arr.enumerate() {
                    if let _ = a.element.jsonDict {
                        replaceValue(key, dict: &dict[k]![a.index]!,string: str)
                    }
                }
            }
        }
    }
}

func replaceValue(key:String, inout dict:JSONDictionary, number num:NSNumber) {
    
    // make sure we can make type changes everywhere
    dict.restrictTypeChanges = false
    dict.inheritRestrictions = true
    
    if dict.keys.contains(key) {
        dict[key] = num
    }
        
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in arr.enumerate() {
                    if let _ = a.element.jsonDict {
                        replaceValue(key, dict: &dict[k]![a.index]!,number: num)
                    }
                }
            }
        }
    }
}

func replaceValueWithNull(key:String, inout dict:JSONDictionary) {
    
    // make sure we can make type changes everywhere
    dict.restrictTypeChanges = false
    dict.inheritRestrictions = true
    
    if dict.keys.contains(key) {
        dict[key] = NSNull()
    }
        
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in arr.enumerate() {
                    if let _ = a.element.jsonDict {
                        replaceValueWithNull(key, dict: &dict[k]![a.index]!)
                    }
                }
            }
        }
    }
}
func searchKeys(key:String, dict:JSONDictionary) -> Value? {
    
    if dict.keys.contains(key) {
        return dict[key]!
    }
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in arr {
                    if let dictionary = a.jsonDict {
                      searchKeys(key, dict: dictionary)
                    }
                }
            }
        }
    }

     return nil

}


