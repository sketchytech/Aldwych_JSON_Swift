# iolcos
JSON parser for Swift - for parsing and re-constituting of parsed data.

The name of this repository follows the logic of many other JSON repositories that the name should be derived from some connection to Jason, the Greek mythological hero. Iolcos was Jason's starting point in the myth of the Golden Fleece, and this JSON parser is a new starting point for the parsing of JSON in Swift.

The parser is capable of handling JSON that has been loaded as NSData and which follows an array or string : value dictionary format. (In other words standard JSON.)
#How to
The code requires the latest Xcode 6.3 Beta installed with Swift 1.2

To use simply copy the contents of the Sources folder into your app or playground. It works with iOS and OS X.
##Parse JSON Data
To parse NSData simply use

`JSONParser.parseDictionary(json:NSData, restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true)`

or 

`JSONParser.parseArray(json:NSData, restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true)`

Default settings do not allow changes of type but do allow values to become null. To enable changes of type change **restrictTypeChanges** to **false** and to prevent nullability of values change **anyValueIsNullable** to **false**.

These properties can be changed at any time, and of course if the JSON is parsed into a constant value then no changes will be possible anyway until the dictionary or array is copied to a variable.
##Retrieve and update values
In order to retrieve a value identify its type, e.g. `if let tName = jsonDictionary["trackName"]?.str {}` or `if let rCount = jsonDictionary["resultCount"]?.num {}`

Updates to results can be made like this `jsonDictionary["results"]?[0]?["trackName"] = "Something"`
#Methods and Properties
There are a range of methods available that will expand with time. They include among others (to be documented soon):
##JSONArray
`jsonArray.append("Hello Swift!") // can be used for strings, numbers, JSONArray, JSONDictiony, NSNull`

`jsonArray.insert("Hello Swift!",atIndex:2) // can be used for strings, numbers, JSONArray, JSONDictiony, NSNull`

`jsonArray.isStringArray() -> Bool // i.e. is exclusively composed of strings, nothing else`

`jsonArray.containsStrings() -> Bool // has strings within array`

`jsonArray.stringArray() -> [String]? // returns only the strings from an array`
##JSONDictionary
`jsonDict.keys: [String]? {get}`

`jsonDict.keysWithStringValues: [String]? {get}`

`jsonDict.keysWithNumberValues: [String]? {get}`

`jsonDict.keysWithNullValues: [String]? {get}`

`jsonDict.keysWithArrayValues: [String]? {get}`

`jsonDict.keysWithDictionaryValues: [String]? {get}`

#Loops

        for (k,v) in jsonDictionary {
            if let aNum = v?.num {
              println(aNum)
            }
        }

and

        for v in jsonArray {
            if let aNum = v?.num {
              println(aNum)
            }
        }


#Round-tripping data
To round-trip the JSON simply write

`NSJSONSerialization.dataWithJSONObject(jsonDictionary.dictionary, options: NSJSONWritingOptions.PrettyPrinted, error: &error)`

or

`NSJSONSerialization.dataWithJSONObject(jsonArray.array, options: NSJSONWritingOptions.PrettyPrinted, error: &error)`

#Refined Handling
For more refined handling of data, additional types can be created. If you add the iTunesData file from the Extras folder then code like this can be can be written:

    var data:NSData?
    if let url = NSURL(string:"https://itunes.apple.com/search?term=b12&limit=10"),
        d = NSData(contentsOfURL: url) {
          data = d
    }
    if let data = data,
        parsedJSON = JSONParser.parseDictionary(data),
        iTD = iTunesData(dict: parsedJSON) {
        var tracks = map(iTD.results, {x in Track(dict:x.jsonDict)})
        let m = map(tracks,{x in "Title: \(x!.trackName), Album: \(x!.collectionName)\n"})
        println(join("\n",m))
        tracks[1]?.trackName = "New Name"
        tracks[1]?.trackName
        var iT = iTD
        if let track = tracks[1] {
            iT.updateTrackDetails(track)
        }
        tracks = map(iT.results, {x in Track(dict:x.jsonDict)})
        let m2 = map(tracks,{x in "Title: \(x!.trackName), Album: \(x!.collectionName)\n"})
        println(join("\n",m2))
        iT.outputJSON()?.writeToFile("/tmp/b12.json", atomically: false)
    }
It's an example of how the data can be filtered but still renconstituted. Note: an explanation of the logic and also suitable patterns for building new types for other APIs is planned. 
#Future Functionality
The aim is to enable the JSONDictionary and JSONArray types to mirror the functionality of Dictionary and Array and to have them adhere to the same protocols. Some of this is already in place and the exact methods and properties that are accessible will be listed here soon.

At present insert and append methods do not restrict type at all. It will be considered how type safety might be applied here so as to restrict the corruption of JSON structure and data. However, if this is a concern then it may well be the place of refined handling types to ensure illegal changes are not made to data.
#Contact
You can get in touch on twitter [@sketchyTech](http://twitter.com/sketchyTech).
