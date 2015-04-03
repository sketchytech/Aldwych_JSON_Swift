//
//  XMLParser.swift
//  SaveFile
//
//  Created by Anthony Levings on 31/03/2015.
//

import Foundation

class XMLParser:NSObject, NSXMLParserDelegate {

    // where the dictionaries for each tag are created
    var elementArray = [JSONDictionary]()
    var contentArray = [JSONArray]()
    // final document array where last dictionary
    var document = JSONDictionary()
   
    
    func parse(xml:NSData) -> JSONDictionary {
        var xml2json = NSXMLParser(data: xml)
        xml2json.delegate = self
        xml2json.parse()
        return document
    }
    
    func parserDidStartDocument(parser: NSXMLParser) {
    
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {

       
        // current dictionary is the newly opened tag
        elementArray.append(JSONDictionary(dict: [elementName:"", "attributes":attributeDict], restrictTypeChanges: false))

        
        // every new tag has an array added to the holdingArr
        contentArray.append(JSONArray(restrictTypeChanges: false))

    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if let str = string {

                // current array is always the last item in holding, add string to array
                contentArray[contentArray.count-1].append(str)
        

            
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        // current array, which might be one string or a nested set of elements is added to the current dictionary
        if contentArray.count > 0 {
            for (k,v) in elementArray.last! {
                if k != "attributes" {
                    elementArray[elementArray.count-1][k] = contentArray.last
                }
            }
            
        }
        
        // add the current dictionary to the array before if there is one
        if contentArray.count > 1 {
         
            // add the dictionary into the previous JSONArray of the holdingArray
            contentArray[contentArray.count-2].append(elementArray[elementArray.count-1])
            
            
         // remove the dictionary
            if elementArray.count > 0 {
                // remove the array of the current dictionary that has already been assigned
                elementArray.removeLast()
            }
            if contentArray.count > 0 {
                contentArray.removeLast()
            }

        }
        
      

 
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        if let doc = elementArray.last { document = doc }
      
    }
    

        
        private static func xmlEntities(str:String) -> String {
            let xmlEntities = ["\"":"&quot;","&":"&amp;","'":"&apos;","<":"lt",">":"&gt;"]
            var strA = ""
            for (k,v) in xmlEntities {
                strA = str.stringByReplacingOccurrencesOfString(k, withString: v, options: nil, range: Range(start: str.startIndex, end: str.endIndex))
            }
            return strA
            
        }
        static func json2xml(json:JSONDictionary)->String? {
            
            let str1 = json2xmlUnchecked(json)
            let str = str1.stringByReplacingOccurrencesOfString("&", withString: "&amp;", options: nil, range: Range(start: str1.startIndex, end: str1.endIndex))
            
            if let d = str.dataUsingEncoding(NSUTF8StringEncoding) {
                println("parsing1")
                let xml = NSXMLParser(data: d)
                if xml.parse() == true {
                    
                    println("parsing")
                    return str
                }
                else {return nil }
            }
            else {return nil }
        }
        private static func json2xmlUnchecked(json:JSONDictionary) -> String {
            
            // TODO: bit of a fudge to allow the method to take a JSONDictionary, think about using protocol or reworking the method, OK for now - it works!
            let jArray = JSONArray(array:[json.dictionary])
            return json2xmlUnchecked(jArray)
        }
        private static func json2xmlUnchecked(json:JSONArray) -> String {
            
            
            var bodyHTML = ""
            for b in json {
                // if it's a string we simply add the string to the bodyHTML string
                if let str = b.str {
                    
                    bodyHTML += xmlEntities(str)
                    // This bit works
                    
                }
                    
                    // if it's a dictionary we know it has a tag key
                else if let dict = b.jsonDict
                {
                    bodyHTML += extractFromDictionaryXml2json(dict)
                    
                }
                    
                    // it shouldn't be an array, and this can most likely be removed
                else if let arr = b.jsonArr
                {
                    bodyHTML += json2xmlUnchecked(arr)
                    
                }
            }
            
            return bodyHTML
        }
    static func extractFromDictionaryXml2json(dict:JSONDictionary) -> String {
        var elementHTML = ""
        for (k,v) in dict {
            // if it matches one in the list of tags in the body template work through that element's array to build the relevant HTML
            if k != "attributes" {
                elementHTML += "<"
                elementHTML += k
                if let atts = dict["attributes"]?.jsonDict {
                    for (k,v) in atts {
                        elementHTML += " "
                        elementHTML += k
                        elementHTML += "=\""
                        if let s = v?.str {
                            elementHTML += s
                            
                        }
                        elementHTML += "\""
                    }
                    
                    elementHTML += ">"
                }
                if let text = v?.str {
                    elementHTML += xmlEntities(text)
                    
                }
                if let text = v?.jsonArr {
                    elementHTML += json2xmlUnchecked(text)
                    
                }
                
                elementHTML += "</"
                elementHTML += k
                elementHTML += ">"
            }
                
            else if let json = dict[k]?.jsonArr {
                // cycle back through
                elementHTML += json2xmlUnchecked(json)
            }
            
        }
        return elementHTML
    }
    
}

