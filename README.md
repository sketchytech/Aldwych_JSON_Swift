# iolcos
JSON parser/creator for Swift - for parsing, editing, creating and reconstituting of parsed data.
#Guiding Principles
The guiding principles of the parser are:

* it should be able to take any valid JSON dictionary or array
* it will enable the structure of the data to be interrogated without any foreknowledge of the values and keys contained
* JSON should remain editable and be able to be reconstituted easily
* internally the types used to manipulate the JSON are type safe and do not store AnyObject values
* the programmer implementing the parser can choose (and easily alter) the interpretation of type safety used for altering values
* JSON can not only be parsed but also created from scratch in a type safe manner

#Naming
The name of this repository follows the logic of many other JSON repositories that the name should be derived from some connection to Jason, the Greek mythological hero. Iolcos was Jason's starting point in the myth of the Golden Fleece, and this JSON parser is a new starting point for the parsing of JSON in Swift.
#Capabilities and Requirements
The parser is capable of handling JSON that has been loaded as NSData and which follows an array or string : value dictionary format. (In other words standard JSON.) It is also capable of creating JSON data from scratch.

The code requires the latest Xcode 6.3 Beta installed with Swift 1.2
#How to Use
To use simply copy the contents of the Sources folder into your app or playground. It works with iOS and OS X.
##Parse JSON Data
To parse NSData simply use

`JSONParser.parseDictionary(json:NSData, restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true) -> JSONDictionary?`

or 

`JSONParser.parseArray(json:NSData, restrictTypeChanges:Bool = true, anyValueIsNullable:Bool = true)  -> JSONArray?`

Default settings do not allow changes of type but do allow values to become null. To enable changes of type change **restrictTypeChanges** to **false** and to prevent nullability of values change **anyValueIsNullable** to **false**.

These properties can be changed at any time, and of course if the JSON is parsed into a constant value then no changes will be possible anyway until the dictionary or array is copied to a variable.
##Retrieve and update values
In order to retrieve a value identify its type, e.g. `if let tName = jsonDictionary["trackName"]?.str {}` or `if let rCount = jsonDictionary["resultCount"]?.num {}`

Updates to results can be made like this `jsonDictionary["results"]?[0]?["trackName"] = "Something"`
#Creation of JSON
    
    var myJSON = JSONDictionary()
    // A JSONDictionary instance has been created
    myJSON["Third"] = "One"
    // A string key with string value has been added
    myJSON["Fourth"] = myJSON
    // A copy of the JSONDictionary has been added creating a nest
    myJSON["Fourth"]?["Third"] = "Two"
    // a nested value is changed
    if let aStr = myJSON["Fourth"]?["Third"]?.str {
        println(aStr) // Two
    }
    // A value is extracted from the nested JSONDictionary
    myJSON.jsonData()?.writeToFile("/tmp/myJSON.json", atomically: false)
    // JSON has now been written to /tmp directory

Once the JSON has been created in this way, the file you created will contain text that looks like this:

`{"Fourth":{"Third":"Two"},"Third":"One"}`

Or similar (remember dictionaries are not ordered in the way that arrays are).
##Initialize with Dictionary<String,T>
It's also possible to initialize the JSONDictionary using a Swift Dictionary, e.g.

    let myDictionary = ["First":9,"Second":1,"Third":"Two"]
    var myJSON = JSONDictionary(dict:myDictionary)
    myJSON.jsonData()?.writeToFile("/tmp/myJSON.json", atomically: false)
    // JSON has now been written to /tmp directory

The created JSON:

`{"First":9,"Second":1,"Third":"Two"}`

Creating JSON using **iolcos** means that you can take advantage of all the associated methods and properties while forgetting about AnyObject and casting. It is also type safe.
#Type Safety
By default we cannot change type once it is set. For example:
    
    var myJSON = JSONDictionary()
    // A JSONDictionary instance has been created
    myJSON["Third"] = "One" // "One"
    myJSON["Third"] = 1 // "One"
    myJSON["Third"] = "Two" // "Two"

But if we were to do this:
    
    var myJSON = JSONDictionary(restrictTypeChanges: false)
    // A JSONDictionary instance has been created
    myJSON["Third"] = "One" // "One"
    myJSON["Third"] = 1 // 1
    myJSON["Third"] = "Two" // "Two"

Then type changes would be freely permitted. But this behaviour changes again if the `restrictTypeChanges` property is later set back to true:

    var myJSON = JSONDictionary(restrictTypeChanges: false)
    // A JSONDictionary instance has been created
    myJSON["Third"] = "One" // "One"
    myJSON["Third"] = 1 // 1
    myJSON.restrictTypeChanges = true
    myJSON["Third"] = "Two" // 1
    
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

`myJSON.jsonData(options:NSJSONWritingOptions = nil, error:NSErrorPointer = nil) -> NSData?`

it works for JSONDictionary and JSONArray

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
