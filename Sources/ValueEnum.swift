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
    case BoolType(Bool)
    
    case NullType(NSNull)
    
    // json object types
    case JSONArrayType(JSONArray)
    case JSONDictionaryType(JSONDictionary)
    
}

// initialization of Value instances
extension Value {
    
    public init (num:NSNumber, restrictTypeChanges:Bool = true, anyValueIsNullable: Bool = true) {
        self = .NumberType(num)
    }
    
    public init (_ val:String, restrictTypeChanges:Bool = true, anyValueIsNullable: Bool = true) {
        self = .StringType(val)
    }
    public init (_ val:NSNull, restrictTypeChanges:Bool = true, anyValueIsNullable: Bool = true) {
        self = .NullType(val)
    }
    public init (bool:Bool, restrictTypeChanges:Bool = true, anyValueIsNullable: Bool = true) {
        self = .BoolType(bool)
    }
    public init (_ val:JSONArray, restrictTypeChanges:Bool = true, anyValueIsNullable: Bool = true) {
        self = .JSONArrayType(val)
    }
    
    public init (_ val:JSONDictionary, restrictTypeChanges:Bool = true, anyValueIsNullable: Bool = true) {
        self = .JSONDictionaryType(val)
    }
    
    
    /*
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
    }*/
    
    
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
        case .NullType( _):
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
        case .NullType( _):
            let a:NSNumber? = nil
            return a
        default:
            return nil
        }
        
    }
    
    public var bool:Bool? {
        switch self {
        case .BoolType(let bool):
            return bool
        default:
            return nil
        }
        
    }
    public var boolOpt:Bool?? {
        switch self {
        case .BoolType(let bool):
            return bool
        case .NullType( _):
            let a:Bool? = nil
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
        case .NullType( _):
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
        case .NullType( _):
            let a:JSONDictionary? = nil
            return a
        default:
            return nil
        }
        
    }
    
    
}
