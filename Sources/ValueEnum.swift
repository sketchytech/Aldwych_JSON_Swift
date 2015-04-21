//
//  ValueEnum.swift
//  JSONParser
//
//  Created by Anthony Levings on 23/03/2015.
//

import Foundation

// enum cases
public enum Value {
    case StringType(String)
    case NumberType(NSNumber)
    
    case NullType(NSNull)
    
    // json object types
    case JSONArrayType(JSONArray)
    case JSONDictionaryType(JSONDictionary)
    
}

// initialization of Value instances
extension Value {
    
    public init (_ val:JSONArray, restrictTypeChanges:Bool = true, anyValueIsNullable: Bool = true) {
        self = .JSONArrayType(val)
    }
    
    public init (_ val:JSONDictionary, restrictTypeChanges:Bool = true, anyValueIsNullable: Bool = true) {
        self = .JSONDictionaryType(val)
    }
    
    
    
    public init? (_ val:AnyObject, restrictTypeChanges:Bool = true, anyValueIsNullable: Bool = true) {
        if let v = val as? String {
            self = .StringType(v)
        }
        else if let v = val as? NSNumber {
            self = .NumberType(v)
        }
            
        else if let v = val as? NSNull {
            self = .NullType(v)
        }
            
            
        else if let v = val as? Dictionary<String,AnyObject> {
            self = Value.JSONDictionaryType(JSONDictionary(dict: v, restrictTypeChanges: restrictTypeChanges, anyValueIsNullable: anyValueIsNullable))
        }
        else if let v = val as? [AnyObject] {
            self = Value.JSONArrayType(JSONArray(array: v, restrictTypeChanges: restrictTypeChanges, anyValueIsNullable: anyValueIsNullable))
        }
        else {
            return nil
        }
    }
    
    
}

// accessing value types
extension Value {
    public var str:String? {
        switch self {
        case .StringType(let str):
            return str
        default:
            return nil
        }
        
    }
    
    public var strOpt:String?? {
        switch self {
        case .StringType(let str):
            return str
        case .NullType(let null):
            let a:String? = nil
            return a
        default:
            return nil
        }
        
    }
    
  
    public var num:NSNumber? {
        switch self {
        case .NumberType(let num):
            return num
        default:
            return nil
        }
        
    }
    public var numOpt:NSNumber?? {
        switch self {
        case .NumberType(let num):
            return num
        case .NullType(let null):
            let a:NSNumber? = nil
            return a
        default:
            return nil
        }
        
    }
    public var null:NSNull? {
        switch self {
        case .NullType(let nullType):
            return nullType
        default:
            return nil
        }
        
    }
    public  var jsonArr:JSONArray? {
        switch self {
        case .JSONArrayType(let jsonArr):
            return jsonArr
        default:
            return nil
        }
        
    }
    public var jsonArrOpt:JSONArray?? {
        switch self {
        case .JSONArrayType(let jsonArr):
            return jsonArr
        case .NullType(let null):
            let a:JSONArray? = nil
            return a
        default:
            return nil
        }
        
    }
    public var jsonDict:JSONDictionary? {
        switch self {
        case .JSONDictionaryType(let jsonDict):
            return jsonDict
        default:
            return nil
        }
        
    }
    
    public var jsonDictOpt:JSONDictionary?? {
        switch self {
        case .JSONDictionaryType(let jsonDict):
            return jsonDict
        case .NullType(let null):
            let a:JSONDictionary? = nil
            return a
        default:
            return nil
        }
        
    }
    
    
}
