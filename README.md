# Iolcos
JSON parser for Swift - for parsing and re-constituting of parsed data
#How to
The code requires the latest Xcode 6.3 Beta installed with Swift 1.2

To use simply copy the file: Resources/Parser into your app or playground. It works with iOS and OS X.

To parse NSData simply use `JSONParser.parseDictionary(json:NSData)` or `JSONParser.parseArray(json:NSData)`

In order to retrieve a value identify its type, e.g. `if let tName = jsonDictionary["trackName"]?.str {}` or `if let rCount = jsonDictionary["resultCount"]?.num {}`

Updates to results can be made like this `jsonDictionary["results"]?[0]?["trackName"] = "Something"`
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

#Contact
You can get in touch on twitter [@sketchyTech](http://twitter.com/sketchyTech).
