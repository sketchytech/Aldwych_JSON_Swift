//
//  parser.swift
//  JSONParser
//
//  Created by Anthony Levings on 11/03/2015.
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
    
    public init? (_ val:AnyObject) {
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
            self = Value.JSONDictionaryType(JSONDictionary(dict: v))
        }
        else if let v = val as? [AnyObject] {
            self = Value.JSONArrayType(JSONArray(array: v))
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
        case .NullType(let null):
            return null
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


// initialization of JSONArray type
public struct JSONArray:SequenceType {
    
    // use dictionary with index as keys for position in array
    private var stringDict:Dictionary<Int,String>?
    private var numDict:Dictionary<Int,NSNumber>?
    private var nullDict:Dictionary<Int,NSNull>?
    // json cases
    private var arrayDict:Dictionary<Int,JSONArray>?
    private var dictDict:Dictionary<Int,JSONDictionary>?
    
    public var count:Int {
        var count = 0
        if let n = stringDict?.count {
            count += n
        }
        if let n = numDict?.count {
            count += n
        }
        if let n = nullDict?.count {
            count += n
        }
        if let n = dictDict?.count {
            count += n
        }
        if let n = arrayDict?.count {
            count += n
        }
        return count
}
    
    public init (array:[AnyObject]) {
        // AJL: replace with map?
        for val in enumerate(array) {
            if let v = val.element as? String {
                if stringDict == nil {
                    self.stringDict = Dictionary<Int,String>()
                }
                if stringDict != nil {
                    stringDict![val.index] = v
                }
                
            }
            else if let v = val.element as? NSNumber {
                if numDict == nil {
                    self.numDict = Dictionary<Int,NSNumber>()
                }
                if numDict != nil {
                    numDict![val.index] = v
                }
                
            }
                
            else if let v = val.element as? NSNull {
                if nullDict == nil {
                    
                    self.nullDict = Dictionary<Int,NSNull>()
                }
                if nullDict != nil {
                    nullDict![val.index] = v
                    
                }
            }
                
            else if let v = val.element as? Dictionary<String, AnyObject> {
                if dictDict == nil {
                    self.dictDict = Dictionary<Int,JSONDictionary>()
                }
                if dictDict != nil {
                    dictDict![val.index] = JSONDictionary(dict: v)
                    
                }
                
                
                
            }
                
            else if let v = val.element as? [AnyObject] {
                if arrayDict == nil {
                    self.arrayDict = Dictionary<Int,JSONArray>()
                }
                if arrayDict != nil {
                    arrayDict![val.index] = JSONArray(array: v)
                }
                
            }
            
        }
        
    }
    
        public var array:[AnyObject] {

        var arr = [AnyObject](count: self.count, repeatedValue: [AnyObject]())
        if stringDict != nil {
            for (k,v) in stringDict! {
                arr[k] = v
            }
        }
        if numDict != nil {
            for (k,v) in numDict! {
                arr[k] = v
            }
        }
        if nullDict != nil {
            for (k,v) in nullDict! {
                arr[k] = v
            }
        }
        
        if dictDict != nil {
            for (k,v) in dictDict! {
                arr[k] = v.dictionary
            }
        }
        if arrayDict != nil {
            for (k,v) in arrayDict! {
                arr[k] = v.array
            }
        }
        return arr
    }
    
    
}
// JSON conform to SequenceType
extension JSONArray {
    public typealias Generator = JSONArrayGenerator
    public func generate() -> Generator {
        // AJL: avoid strong capture of self?
        let gen = Generator(arr: self)
        return gen
    }
}

// methods for returning all strings, numbers, null from an array
extension JSONArray {

    public func isStringArray() -> Bool {
        if stringDict != nil && numDict == nil && nullDict == nil && arrayDict == nil && dictDict == nil {
            return true
        }
        else {
            return false
        }
    }
    
    public func stringArray() -> [String]?  {
        if let v = stringDict?.values {
            var vals = [String]()
            
            vals.extend(v)
            return vals
        }
        return nil
    }
    
    public func containsStrings() -> Bool {
        if stringDict != nil {
            return stringDict!.isEmpty
        }
        return false
    }
}

// getting and setting from subscripts
extension JSONArray {
    public subscript (key:Int) -> String? {
        get {
            
            return stringDict?[key]
            
        }
        set(newValue) {
            // AJL: currently the restriction here is that if a key has a string value it can be changed but a new value for a new key cannot be added - would need to add a statement to create stringDict if not present and alter code if that was required
            if stringDict?[key] != nil {
                stringDict?[key] = newValue
            }
        }
    }
    
    public subscript (key:Int) -> NSNumber? {
        get {
            return numDict?[key]
        }
        set(newValue) {
            if numDict?[key] != nil  {
                numDict?[key] = newValue
            }
        }
    }
    
    public subscript (key:Int) -> NSNull? {
        get {
            return nullDict?[key]
        }
        set(newValue) {
            if nullDict?[key] != nil {
                nullDict?[key] = newValue
            }
        }
    }
    
    public subscript (key:Int) -> JSONArray? {
        get {
            return arrayDict?[key]
        }
        set(newValue) {
            if arrayDict?[key] != nil {
                arrayDict?[key] = newValue
            }
        }
    }
    
    
    public subscript (key:Int) -> JSONDictionary? {
        get {
            
            return dictDict?[key]
            
        }
        set(newValue) {
            if dictDict?[key] != nil {
                dictDict?[key] = newValue
            }
        }
    }
    
    
}

// add methods for dictionary, avoid accidental additions
extension JSONArray {
    // Append method
    public mutating func append(str:String) {
    if stringDict == nil {
stringDict = Dictionary<Int,String>()
}
        if stringDict != nil {
        stringDict![self.count] = str
}
    }
    public mutating func append(num:NSNumber) {
        if stringDict == nil {
            numDict = Dictionary<Int,NSNumber>()
        }
        if numDict != nil {
            numDict![self.count] = num
        }
    }
    
    public mutating func append(null:NSNull) {
        if nullDict == nil {
            nullDict = Dictionary<Int,NSNull>()
        }
        if nullDict != nil {
            nullDict![self.count] = null
        }
    }
    
    public mutating func append(dict:JSONDictionary) {
        if dictDict == nil {
            dictDict = Dictionary<Int,JSONDictionary>()
        }
        if dictDict != nil {
            dictDict![self.count] = dict
        }
    }
    
    public mutating func append(arr:JSONArray) {
        if arrayDict == nil {
            arrayDict = Dictionary<Int,JSONArray>()
        }
        if arrayDict != nil {
            arrayDict![self.count] = arr
        }
    }
    
    // TODO: extend() method

    // TODO: insert() method
    
    // TODO: removeAtIndex(), etc. methods
}

// returning an instance of Value type
extension JSONArray {
    
    public subscript (key:Int) -> Value? {
        get {
            
            if let a = stringDict?[key] {
                return Value(a)
            }
            else if let a = numDict?[key] {
                return Value(a)
            }
                
            else if let a = nullDict?[key] {
                return Value(a)
            }
                
            else if let a = dictDict?[key] {
                return Value.JSONDictionaryType(a)
            }
                
            else if let a = arrayDict?[key] {
                return Value.JSONArrayType(a)
            }
            
            
            return nil
        }
        
        
    }
    
    
    
}

// return JSON data
extension JSONArray {
    public func jsonData() -> NSData? {
        return NSJSONSerialization.dataWithJSONObject(self.array, options: nil, error: nil)
    }
}

// JSONArray Generator
public struct JSONArrayGenerator:GeneratorType {
    // use dictionary with index as keys for position in array
    private let arr:JSONArray
    private var i:Int
    
    init(arr:JSONArray) {
        self.arr = arr
        self.i = 0
    }
    
    mutating public func next() -> Value? {
        
        if let v:Value? = arr[i] {
            ++i
            return v
        }
        
        // reset value
        i = 0
        return nil
    }
}

// JSONDictionary Generator
public struct JSONDictionaryGenerator:GeneratorType {
    // use dictionary with index as keys for position in array
    private let dict:JSONDictionary
    private let keys:[String]
    private var i:Int
    
    
    
    public init(dict:JSONDictionary) {
        self.dict = dict
        self.keys = dict.keys
        self.i = 0
    }
    
    mutating public func next() -> (String,Value?)? {
        if i < keys.count {
            let key = keys[i]
            if let v:Value? = dict[key] {
                ++i
                return (key, v)
            }
        }
        // reset value
        i = 0
        return nil
    }
}

public struct JSONDictionary:SequenceType {
    
    private var i = 0
    private lazy var dictionaryKeys:[String] = self.keys
    
    private var stringDict:Dictionary<String,String>?
    private var numDict:Dictionary<String,NSNumber>?
    private var nullDict:Dictionary<String,NSNull>?
    
    private var dictDict:Dictionary<String,JSONDictionary>?
    private var arrayDict:Dictionary<String,JSONArray>?
    
    public var dictionary:Dictionary<String,NSObject> {
        var dictionary = Dictionary<String,NSObject>()
        
       
        if let sD = stringDict  {
            for (k,v) in sD {
                dictionary[k] = v as NSObject
            }
        }
        if let nD = numDict {
            for (k,v) in nD {
                dictionary[k] = v as NSObject
            }
        }
        if let nuD = nullDict {
            for (k,v) in nuD {
                dictionary[k] = v as NSObject
            }
        }
        if let dD = dictDict {
            for (k,v) in dD {
                dictionary[k] = v.dictionary as NSObject
                
            }
        }
        if let aD = arrayDict {
            for (k,v) in aD {
                dictionary[k] = v.array as NSObject
            }
        }
        return dictionary
    }
    
    
    public init (dict:Dictionary<String,AnyObject>) {
        // AJL: replace with map?
        for (k,v) in dict {
            if let v = v as? String {
                if stringDict == nil {
                    stringDict = Dictionary<String,String>()
                }
                if stringDict != nil {
                    stringDict![k] = v
                }
            }
            else if let v = v as? NSNumber {
                if numDict == nil {
                    numDict = Dictionary<String,NSNumber>()
                }
                if numDict != nil {
                    numDict![k] = v
                }
            }
                
            else if let v = v as? NSNull {
                if nullDict == nil {
                    nullDict = Dictionary<String,NSNull>()
                }
                if numDict != nil {
                    nullDict![k] = v
                }
            }
                
            else if let v = v as? Dictionary<String, AnyObject> {
                if dictDict == nil {
                    dictDict = Dictionary<String,JSONDictionary>()
                }
                if dictDict != nil {
                    dictDict![k] = JSONDictionary(dict: v)
                }
            }
            else if let v = v as? [AnyObject] {
                if arrayDict == nil {
                    arrayDict = Dictionary<String,JSONArray>()
                }
                if arrayDict != nil {
                    arrayDict![k] = JSONArray(array: v)
                }
                
            }
        }
        
    }
    
    
    
}

extension JSONDictionary {
    public subscript (key:String) -> String? {
        get {
            return stringDict?[key]
        }
        set(newValue) {
            if stringDict?[key] != nil {
                stringDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                // if a string dictionary doesn't already exist, it will be created before the key and value is added (same for each type)
                if stringDict == nil {
                    stringDict = Dictionary<String,String>()
                }
                if stringDict != nil {
                    stringDict?[key] = newValue
                }
            }
        }
    }
    
    public subscript (key:String) -> NSNumber? {
        get {
            return numDict?[key]
        }
        set(newValue) {
            if numDict?[key] != nil {
                numDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                if numDict == nil {
                    numDict = Dictionary<String,NSNumber>()
                }
                if numDict != nil {
                    numDict?[key] = newValue
                }
            }
        }
    }
    
    public subscript (key:String) -> NSNull? {
        get {
            return nullDict?[key]
        }
        set(newValue) {
            if nullDict?[key] != nil {
                nullDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                if nullDict == nil {
                    nullDict = Dictionary<String,NSNull>()
                }
                if nullDict != nil {
                    nullDict?[key] = newValue
                }
            }
        }
    }
    
    public subscript (key:String) -> JSONDictionary? {
        get {
            return dictDict?[key]
        }
        set(newValue) {
            if dictDict?[key] != nil {
                dictDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                if dictDict == nil {
                    dictDict = Dictionary<String,JSONDictionary>()
                }
                if dictDict != nil {
                    dictDict?[key] = newValue
                }
            }
            
        }
    }
    
    
    public subscript (key:String) -> JSONArray? {
        get {
            return arrayDict?[key]
        }
        set(newValue) {
            if arrayDict?[key] != nil {
                arrayDict?[key] = newValue
            }
            else if nonExistentKey(key) {
                if arrayDict == nil {
                    arrayDict = Dictionary<String,JSONArray>()
                }
                if arrayDict != nil {
                    arrayDict?[key] = newValue
                }
                
            }
        }
    }
    
    
    public subscript (key:String) -> Value? {
        get {
            
            if let a = stringDict?[key] {
                return Value(a)
            }
                
            else if let a = numDict?[key] {
                return Value(a)
            }
                
            else if let a = nullDict?[key] {
                return Value(a)
            }
                
            else if let a = dictDict?[key] {
                return Value.JSONDictionaryType(a)
            }
            else if let a = arrayDict?[key] {
                return Value.JSONArrayType(a)
            }
            
            
            return nil
        }
        
    }
    
}

// accessing keys and keys for types
extension JSONDictionary {
    // retrieve keys from dictionaries (all or based on Type)
    public var keys:[String] {
        var keys = [String]()
        if stringDict != nil {
            keys.extend(stringDict!.keys)
        }
        if numDict != nil {
            keys.extend(numDict!.keys)
        }
        if nullDict != nil {
            keys.extend(nullDict!.keys)
        }
        
        if dictDict != nil {
            keys.extend(dictDict!.keys)
        }
        if arrayDict != nil {
            keys.extend(arrayDict!.keys)
        }
        
        return keys
    }
    public var keysWithStringValues:[String]? {
        if stringDict != nil {
            var keys = [String]()
            keys.extend(stringDict!.keys)
            return keys
        }
        return nil
    }
    public var keysWithNumberValues:[String]? {
        if numDict != nil {
            var keys = [String]()
            keys.extend(numDict!.keys)
            return keys
        }
        return nil
    }
    public var keysWithNullValues:[String]? {
        if nullDict != nil {
            var keys = [String]()
            keys.extend(nullDict!.keys)
            return keys
        }
        return nil
    }
    public var keysWithDictionaryValues:[String]? {
        if dictDict != nil {
            var keys = [String]()
            keys.extend(dictDict!.keys)
            return keys
        }
        return nil
    }
    
}

// add methods for dictionary, avoid accidental additions
extension JSONDictionary {
    
    func nonExistentKey(key:String) -> Bool {
        if stringDict?[key] == nil && numDict?[key] == nil && nullDict?[key] == nil && arrayDict?[key] == nil && dictDict?[key] == nil {
            return true
        }
        return false
    }
    
}

// JSON conform to SequenceType
extension JSONDictionary {
    public typealias Generator = JSONDictionaryGenerator
    public func generate() -> Generator {
        // AJL: avoid strong capture of self?
        let gen = Generator(dict: self)
        return gen
    }
}
// return JSON data
extension JSONDictionary {
    public func jsonData()->NSData? {
        return NSJSONSerialization.dataWithJSONObject(self.dictionary, options: nil, error: nil)
    }
}

// generator
extension JSONDictionary {
    
    typealias Element = Value
    mutating func next() -> Element? {
        
        let k = dictionaryKeys[i]
        if let v = stringDict?[k] {
            ++i
            return Value(v)
        }
        else if let v = numDict?[k] {
            ++i
            return Value(v)
        }
        else if let v = nullDict?[k] {
            ++i
            return Value(v)
        }
        else if let v = dictDict?[k] {
            ++i
            return Value.JSONDictionaryType(v)
        }
        else if let v = arrayDict?[k] {
            ++i
            return Value.JSONArrayType(v)
        }
        
        // reset value
        i = 0
        return nil
    }
    
}
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
