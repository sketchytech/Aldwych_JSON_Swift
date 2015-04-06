//
//  JSONSearch.swift
//  SaveFile
//
//  Created by Anthony Levings on 06/04/2015.

//

import Foundation

func replaceValue(key:String, inout dict:JSONDictionary, array arra:JSONArray) {
    
    // make sure we can make type changes everywhere
    dict.restrictTypeChanges = false
    dict.inheritRestrictions = true
    
    if contains(dict.keys,key) {
        dict[key] = arra
    }
        
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in enumerate(arr) {
                    if let dictionary = a.element.jsonDict {
                        replaceValue(key, &dict[k]![a.index]!,array: arra)
                    }
                }
            }
        }
    }
    
    
}

func replaceValue(key:String, inout dict:JSONDictionary, dictionary dic:JSONDictionary) {
    
    // make sure we can make type changes everywhere
    dict.restrictTypeChanges = false
    dict.inheritRestrictions = true
    
    if contains(dict.keys,key) {
        dict[key] = dic
    }
        
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in enumerate(arr) {
                    if let dictionary = a.element.jsonDict {
                        replaceValue(key, &dict[k]![a.index]!,dictionary: dic)
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
    
    if contains(dict.keys,key) {
        dict[key] = str
    }
        
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in enumerate(arr) {
                    if let dictionary = a.element.jsonDict {
                        replaceValue(key, &dict[k]![a.index]!,string: str)
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
    
    if contains(dict.keys,key) {
        dict[key] = num
    }
        
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in enumerate(arr) {
                    if let dictionary = a.element.jsonDict {
                        replaceValue(key, &dict[k]![a.index]!,number: num)
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
    
    if contains(dict.keys,key) {
        dict[key] = NSNull()
    }
        
    else if let dK = dict.keysWithArrayValues {
        for k in dK {
            if let arr = dict[k]?.jsonArr {
                for a in enumerate(arr) {
                    if let dictionary = a.element.jsonDict {
                        replaceValueWithNull(key, &dict[k]![a.index]!)
                    }
                }
            }
        }
    }
}
