//
//  JSONArray.swift
//  JSONParser
//
//  Created by Anthony Levings on 23/03/2015.
//

import Foundation

// initialization of JSONArray type
public struct JSONArray {
    //TODO: make restrictions work for nest dictionaries when changed after initialization
    public var inheritRestrictions = true
    public var restrictTypeChanges:Bool
    public var anyValueIsNullable:Bool
    // use dictionary with index as keys for position in array
    private var stringDict:Dictionary<Int,String>?
    private var numDict:Dictionary<Int,NSNumber>?
    private var boolDict:Dictionary<Int,Bool>?
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
        if let n = boolDict?.count {
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
    public init (restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true) {
        self.anyValueIsNullable = anyValueIsNullable
        self.restrictTypeChanges = restrictTypeChanges
        
    }
    
    public init (array:[AnyObject], handleBool:Bool = true, restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true) {
        // AJL: replace with map?
        self.anyValueIsNullable = anyValueIsNullable
        self.restrictTypeChanges = restrictTypeChanges
        for val in array.enumerate() {
            if let v = val.element as? String {
                if stringDict == nil {
                    self.stringDict = Dictionary<Int,String>()
                }
                stringDict![val.index] = v
                
                
            }
                
            else if let v = val.element as? NSNumber {
                // test to see if a bool
                if handleBool && v.isBoolNumber() {
                    if boolDict == nil {
                        boolDict = Dictionary<Int,Bool>()
                    }
                    if boolDict != nil {
                        boolDict![val.index] = Bool(v)
                    }
                }
                else {
                if numDict == nil {
                    numDict = Dictionary<Int,NSNumber>()
                }
                if numDict != nil {
                    numDict![val.index] = v
                    
                    }
                }
            }
           
                
            else if let v = val.element as? NSNull {
                if nullDict == nil {
                    
                    self.nullDict = Dictionary<Int,NSNull>()
                }
                nullDict![val.index] = v
                
                
            }
                
            else if let v = val.element as? Dictionary<String, AnyObject> {
                if dictDict == nil {
                    self.dictDict = Dictionary<Int,JSONDictionary>()
                }
                
                dictDict![val.index] = JSONDictionary(dict: v, handleBool:handleBool, restrictTypeChanges: restrictTypeChanges, anyValueIsNullable: anyValueIsNullable)
                
                
            }
                
            else if let v = val.element as? [AnyObject] {
                if arrayDict == nil {
                    self.arrayDict = Dictionary<Int,JSONArray>()
                }
                
                arrayDict![val.index] = JSONArray(array: v, handleBool:handleBool, restrictTypeChanges: restrictTypeChanges, anyValueIsNullable: anyValueIsNullable)
                
            }
            
        }
        
    }
    
    
    public var array:[AnyObject] {
        
        var arr = [AnyObject](count: self.count, repeatedValue: 0)
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
        if boolDict != nil {
            for (k,v) in boolDict! {
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
                arr[k] = v.dictionary as [String:AnyObject]
            }
        }
        if arrayDict != nil {
            for (k,v) in arrayDict! {
                arr[k] = v.array as [AnyObject]
            }
        }
        return arr
    }
    

    
    public var nsArray:NSArray {
        
        let arr = NSMutableArray(capacity: self.count)
        if stringDict != nil {
            for (k,v) in stringDict! {
                arr[k] = v as NSString
            }
        }
        if numDict != nil {
            for (k,v) in numDict! {
                arr[k] = v as NSNumber
            }
        }
        if boolDict != nil {
            for (k,v) in boolDict! {
                arr[k] = v as Bool
            }
        }
        if nullDict != nil {
            for (k,v) in nullDict! {
                arr[k] = v as NSNull
            }
        }
        
        if dictDict != nil {
            for (k,v) in dictDict! {
                arr[k] = v.nsDictionary as NSDictionary
            }
        }
        if arrayDict != nil {
            for (k,v) in arrayDict! {
                arr[k] = v.nsArray as NSArray
            }
        }
        return arr
    }
    
    
}
// JSON conform to SequenceType
extension JSONArray:SequenceType {
    public typealias Generator = JSONArrayGenerator
    public func generate() -> Generator {
        // AJL: avoid strong capture of self?
        let gen = Generator(arr: self)
        return gen
    }
}
extension JSONArray {
    mutating func removeLast() {
            let a = self.count-1
            stringDict?.removeValueForKey(a)
            numDict?.removeValueForKey(a)
            boolDict?.removeValueForKey(a)
            nullDict?.removeValueForKey(a)
            arrayDict?.removeValueForKey(a)
            dictDict?.removeValueForKey(a)
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
    // returns all the values from the string dictionary
    public func stringArray() -> [String]?  {
        if let v = stringDict?.values {
            return v.map{$0}
        }
        return nil
    }
    
    public func containsStrings() -> Bool {
        if stringDict != nil {
            return true
        }
        return false
    }
    
    public func containsNull() -> Bool {
        if nullDict != nil {
            return true
        }
        return false
    }
    public func dictionaryArray() -> [JSONDictionary]?  {
        if let v = dictDict?.values {
            return v.map{$0}
        }
        return nil
    }
    
}

// getting and setting from subscripts
extension JSONArray {
    public subscript (key:Int) -> String? {
        get {
            
            return stringDict?[key]
            
        }
        set(newValue) {
            
            if stringDict?[key] != nil {
                stringDict?[key] = newValue
            }
            else if nullDict?[key] != nil {
                nullDict?.removeValueForKey(key)
                if nullDict?.isEmpty == true {
                    nullDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if stringDict == nil {
                    stringDict = Dictionary<Int,String>()
                }
                stringDict?[key] = newValue
            }
            // the JSONArray type uses nil as an indicator of emptiness, so if the final value/key is removed then the dictionary should reset to nil
            else if restrictTypeChanges == false {
                numDict?.removeValueForKey(key)
                if numDict?.isEmpty == true {
                    numDict = nil
                }
                boolDict?.removeValueForKey(key)
                if boolDict?.isEmpty == true {
                    boolDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                dictDict?.removeValueForKey(key)
                if dictDict?.isEmpty == true {
                    dictDict = nil
                }
                // because nil is an indicator of emptiness, it might be the case that no stringDict exists, and so it must be created if this is the case
                if stringDict == nil {
                    stringDict = Dictionary<Int,String>()
                }
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
                // if value starts as null, we assume it can be replaced, but there's no way of knowing what it can be replaced with so we must allow anything in the first instance
            else if nullDict?[key] != nil {
                nullDict?.removeValueForKey(key)
                if nullDict?.isEmpty == true {
                    nullDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if numDict == nil {
                    numDict = Dictionary<Int,NSNumber>()
                }
                numDict?[key] = newValue
            }
                // if the restriction of changing types has been turned off then anything can be replaced
            else if restrictTypeChanges == false {
                stringDict?.removeValueForKey(key)
                if stringDict?.isEmpty == true {
                    stringDict = nil
                }
                boolDict?.removeValueForKey(key)
                if boolDict?.isEmpty == true {
                    boolDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                dictDict?.removeValueForKey(key)
                if dictDict?.isEmpty == true {
                    dictDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if numDict == nil {
                    numDict = Dictionary<Int,NSNumber>()
                }
                // add value to numDict
                numDict?[key] = newValue
                
            }
        }
    }
    
    public subscript (key:Int) -> Bool? {
        get {
            return boolDict?[key]
        }
        set(newValue) {
            if boolDict?[key] != nil  {
                boolDict?[key] = newValue
            }
                // if value starts as null, we assume it can be replaced, but there's no way of knowing what it can be replaced with so we must allow anything in the first instance
            else if nullDict?[key] != nil {
                nullDict?.removeValueForKey(key)
                if nullDict?.isEmpty == true {
                    nullDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if boolDict == nil {
                    boolDict = Dictionary<Int,Bool>()
                }
                boolDict?[key] = newValue
            }
                // if the restriction of changing types has been turned off then anything can be replaced
            else if restrictTypeChanges == false {
                stringDict?.removeValueForKey(key)
                if stringDict?.isEmpty == true {
                    stringDict = nil
                }
                numDict?.removeValueForKey(key)
                if numDict?.isEmpty == true {
                    numDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                dictDict?.removeValueForKey(key)
                if dictDict?.isEmpty == true {
                    dictDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if boolDict == nil {
                    boolDict = Dictionary<Int,Bool>()
                }
                // add value to numDict
                boolDict?[key] = newValue
                
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
                // any value is nullable
            else if anyValueIsNullable == true {
                numDict?.removeValueForKey(key)
                if numDict?.isEmpty == true {
                    numDict = nil
                }
                stringDict?.removeValueForKey(key)
                if stringDict?.isEmpty == true {
                    stringDict = nil
                }
                boolDict?.removeValueForKey(key)
                if boolDict?.isEmpty == true {
                    boolDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                dictDict?.removeValueForKey(key)
                if dictDict?.isEmpty == true {
                    dictDict = nil
                }
                if nullDict == nil {
                    nullDict = Dictionary<Int,NSNull>()
                }
                nullDict?[key] = newValue
            }
            
            
            
        }
    }
    
    public subscript (key:Int) -> JSONArray? {
        get {
            var arrayD = self.arrayDict?[key]
            if inheritRestrictions == true {
                arrayD?.restrictTypeChanges = self.restrictTypeChanges
                arrayD?.anyValueIsNullable = self.anyValueIsNullable
            }

            return arrayD
        }
        set(newValue) {
            if arrayDict?[key] != nil {
                arrayDict?[key] = newValue
            }
            else if nullDict?[key] != nil {
                nullDict?.removeValueForKey(key)
                if nullDict?.isEmpty == true {
                    nullDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if arrayDict == nil {
                    arrayDict = Dictionary<Int,JSONArray>()
                }
                arrayDict?[key] = newValue
            }
            else if restrictTypeChanges == false {
                stringDict?.removeValueForKey(key)
                if stringDict?.isEmpty == true {
                    stringDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                boolDict?.removeValueForKey(key)
                if boolDict?.isEmpty == true {
                    boolDict = nil
                }
                dictDict?.removeValueForKey(key)
                if dictDict?.isEmpty == true {
                    dictDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if arrayDict == nil {
                    arrayDict = Dictionary<Int,JSONArray>()
                }
                // add value to numDict
                arrayDict?[key] = newValue
                
            }

        }
    }
    
    
    public subscript (key:Int) -> JSONDictionary? {
        get {
            var dictD = self.dictDict?[key]
            
            if inheritRestrictions == true {
                dictD?.restrictTypeChanges = self.restrictTypeChanges
                dictD?.anyValueIsNullable = self.anyValueIsNullable
            }
            
            return dictD
            
        }
        set(newValue) {
            if dictDict?[key] != nil {
                dictDict?[key] = newValue
            }
            else if nullDict?[key] != nil {
                nullDict?.removeValueForKey(key)
                if nullDict?.isEmpty == true {
                    nullDict = nil
                }
                dictDict?[key] = newValue
            }
            else if restrictTypeChanges == false {
                stringDict?.removeValueForKey(key)
                if stringDict?.isEmpty == true {
                    stringDict = nil
                }
                boolDict?.removeValueForKey(key)
                if boolDict?.isEmpty == true {
                    boolDict = nil
                }
                arrayDict?.removeValueForKey(key)
                if arrayDict?.isEmpty == true {
                    arrayDict = nil
                }
                numDict?.removeValueForKey(key)
                if numDict?.isEmpty == true {
                    numDict = nil
                }
                // check to make sure there is a numDict and create one if not
                if dictDict == nil {
                    dictDict = Dictionary<Int,JSONDictionary>()
                }
                // add value to numDict
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
        if numDict == nil {
            numDict = Dictionary<Int,NSNumber>()
        }
        if numDict != nil {
            numDict![self.count] = num
        }
    }
    public mutating func append(bool:Bool) {
        if boolDict == nil {
            boolDict = Dictionary<Int,Bool>()
        }
        if boolDict != nil {
            boolDict![self.count] = bool
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
    
}

extension JSONArray {
    // extension to enable insert method
    mutating func updatePositions(fromIndex:Int,by:Int = 1) {
        
        if var strD = stringDict
        {
            // update stringDict
            for (k,v) in strD {
                if k >= fromIndex {
                    strD[k+by] = v
                }
            }
            stringDict = strD
        }
        if var numD = numDict
        {
            // update numDict
            for (k,v) in numD {
                if k >= fromIndex {
                    numD[k+by] = v
                }
            }
            numDict = numD
        }
        
        if var boolD = boolDict
        {
            // update boolDict
            for (k,v) in boolD {
                if k >= fromIndex {
                    boolD[k+by] = v
                }
            }
            boolDict = boolD
        }
        
        if var nulD = nullDict
        {
            // update nullDict
            for (k,v) in nulD {
                if k >= fromIndex {
                    nulD[k+by] = v
                }
            }
            nullDict = nulD
        }
        
        if var arrD = arrayDict
        {
            // update arrayDict
            for (k,v) in arrD {
                if k >= fromIndex {
                    arrD[k+by] = v
                }
            }
            arrayDict = arrD
        }
        
        if var dictD = dictDict
        {
            // update dictDict
            for (k,v) in dictD {
                if k >= fromIndex {
                    dictD[k+by] = v
                }
            }
            dictDict = dictD
        }
    }
 
    public mutating func insert(str:String, atIndex:Int) {
        
        if self.count-1 >= atIndex {
            updatePositions(atIndex)
            if stringDict == nil {
                stringDict = Dictionary<Int,String>()
            }
            stringDict?[atIndex] = str
        }
        
    }
    public mutating func insert(num:NSNumber, atIndex:Int) {
        if self.count-1 >= atIndex {
            updatePositions(atIndex)
            if numDict == nil {
                numDict = Dictionary<Int,NSNumber>()
            }
            numDict?[atIndex] = num
        }
    }
    
    public mutating func insert(bool:Bool, atIndex:Int) {
        if self.count-1 >= atIndex {
            updatePositions(atIndex)
            if boolDict == nil {
                boolDict = Dictionary<Int,Bool>()
            }
            boolDict?[atIndex] = bool
        }
    }
    
    public mutating func insert(null:NSNull, atIndex:Int) {
        if self.count-1 >= atIndex {
            updatePositions(atIndex)
            if nullDict == nil {
                nullDict = Dictionary<Int,NSNull>()
            }
            nullDict?[atIndex] = null
        }
    }
    
    public mutating func insert(dict:JSONDictionary, atIndex:Int) {
        if self.count-1 >= atIndex {
            updatePositions(atIndex)
            if dictDict == nil {
                dictDict = Dictionary<Int,JSONDictionary>()
            }
            dictDict?[atIndex] = dict
        }
    }
    
    public mutating func insert(arr:JSONArray, atIndex:Int) {
        if self.count-1 >= atIndex {
            updatePositions(atIndex)
            if arrayDict == nil {
                arrayDict = Dictionary<Int,JSONArray>()
            }
            arrayDict?[atIndex] = arr
        }
    }
    
    // TODO: extend() method
    
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
                return Value(num:a)
            }
            else if let a = boolDict?[key] {
                return Value(bool:a)
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
    public func jsonData(options:NSJSONWritingOptions = []) throws -> NSData {
        return try NSJSONSerialization.dataWithJSONObject(self.array, options: options)
    }
    
    public func stringify(options:NSJSONWritingOptions = []) throws -> String {
        let error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        let data = try NSJSONSerialization.dataWithJSONObject(self.array, options: options)
        let count = data.length / sizeof(UInt8)
            
        // create array of appropriate length:
        var array = [UInt8](count: count, repeatedValue: 0)
            
        // copy bytes into array
        data.getBytes(&array, length:count * sizeof(UInt8))
            
            
        if let value = String(bytes: array, encoding: NSUTF8StringEncoding) {
            return value
        }
        throw error
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

