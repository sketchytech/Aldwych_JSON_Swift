//
//  iTunesDataStruct.swift
//  JSONParser
//
//  Created by Anthony Levings on 12/03/2015.
//

import Foundation

public struct iTunesData {
    public var resultCount:Int {
        return results.count
    }
    public var results:JSONArray
    
    public init?(dict:JSONDictionary) {
        if let arr = dict["results"]?.jsonArr {
            results = arr
        }
        else {
            return nil
        }
    }
    
    public subscript (index:Int) -> JSONDictionary? {
        get {
            return results[index]
        }
        
        set(newValue) {
            if let nv = newValue  {
                results[index] = nv
            }
        }
    }
    public mutating func updateTrackDetails(track:Track) {
        var index:Int?
        for a in enumerate(self.results) {
            if a.element.jsonDict?["trackId"]?.num == track.trackId {
index = a.index
            }
        }
        if let ind = index {
        self.results[ind]?["trackName"] = track.trackName
            self.results[ind]?["collectionName"] = track.collectionName
        }
    }
    public func outputJSON() -> NSData? {
        var aDict = Dictionary<String,AnyObject>()
        aDict["resultCount"] = resultCount
        aDict["results"] = results.array
        return NSJSONSerialization.dataWithJSONObject(aDict, options: nil, error: nil)
    }
}

public struct Track {
   public var trackName:String, collectionName:String, trackId:Int
    
    public init?(dict:JSONDictionary?) {
        if let tN = dict?["trackName"]?.str,
        cN = dict?["collectionName"]?.str,
        tI = dict?["trackId"]?.num {
            trackName = tN
            collectionName = cN
            if let tId = tI as? Int {
            trackId = tId
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    // maybe this function should be in the iTunes Data
    public func updateTrackDetails(inout array:iTunesData) {
        // look up how to make this an inout function?

        var jA = JSONArray(array: [AnyObject]())
        for a in array.results {
            
            if a.jsonDict?["trackId"]?.num == trackId {
                println("found")
               a.jsonDict?["trackName"] == trackName
                a.jsonDict?["collectionName"] == collectionName
                jA.append(a.jsonDict!)
            }
            
            else {
                jA.append(a.jsonDict!)
            }
            
        }
array.results = jA
    
    }
}
