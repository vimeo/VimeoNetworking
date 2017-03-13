//
//  FakeDataSource.swift
//  Vimeo
//
//  Created by Westendorf, Michael on 7/25/16.
//  Copyright © 2016 Vimeo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
@testable import VimeoNetworkingExample_iOS

class FakeDataSource<T: VIMMappable>
{
    fileprivate let mapper = VIMObjectMapper()
    
    var items: [T]?
    var error: NSError?
    
    init(jsonData: [String: AnyObject], keyPath: String)
    {                
        mapper.addMappingClass(T.self, forKeypath: keyPath)
        
        let mappedData = mapper.applyMappingToJSON(jsonData)
        if let objects = mappedData["data"] as? [T]
        {
            self.items = objects
        }
        else if let object = mappedData as? T
        {
            self.items = [object]
        }
    }

    static func loadJSONFile(_ jsonFileName: String, withExtension: String) -> [String: AnyObject]
    {
        let jsonFilePath = Bundle.main.path(forResource: jsonFileName, ofType: withExtension)
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonFilePath!))
        let jsonDict = try! JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.allowFragments)
        
        return (jsonDict as? [String: AnyObject])!
    }
}
