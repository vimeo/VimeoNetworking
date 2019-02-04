//
//  VIMCinemaItem.swift
//  VimeoNetworking
//
//  Created by Westendorf, Michael on 9/26/16.
//  Copyright © 2016 Vimeo (https://vimeo.com)
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

public class VIMProgrammedContent: VIMModelObject {
    @objc dynamic public private(set) var uri: String?
    @objc dynamic public private(set) var name: String?
    @objc dynamic public private(set) var type: String?
    @objc dynamic public private(set) var content: NSArray?
 
    @objc dynamic private var metadata: [String: Any]?
    @objc dynamic private var connections: [String: Any]?
    
    private struct Constants {
        static let ConnectionsKey = "connections"
        static let ContentKey = "content"
        static let MetadataKey = "metadata"
    }
    
    // MARK: Public API
    
    public func connectionWithName(connectionName: String) -> VIMConnection? {
        return self.connections?[connectionName] as? VIMConnection
    }
    
    //Note: No super call in this method, see explanation in didFinishMapping() [MW] 10/19/16
    override public func getClassForCollectionKey(_ key: String!) -> AnyClass! {
        if key == Constants.ContentKey {
            return VIMVideo.self
        }
        
        return nil
    }
    
    //Note: No super call in this method, see explanation in didFinishMapping() [MW] 10/19/16
    override public func getClassForObjectKey(_ key: String!) -> AnyClass? {
        if key == Constants.MetadataKey {
            return NSMutableDictionary.self
        }
        else if key == Constants.ContentKey {
            return NSArray.self
        }
        
        return nil
    }
    
    public override func didFinishMapping() {
        //Note: the super implementation of this method is not being called here because this method does not actually exist in the base class (VIMModelObject).  This method is declared optional in the VIMMappable protocol
        //that VIMModelObject implements.  There seems to be a bug in swift where the compiler is seeing the optional method as a part of the base class, so it won't compile unless we include the override keyword.
        //Calling super.didFinishMapping() will cause the app to crash because of an unknown selector, however if you attempt to test to see if the selector exists before calling it (super.respondsToSelector), the check will
        //succeed even though the method exists in the subclass and not the super class.  [MW] 10/3/16
        
        self.parseConnections()
    }
    
    // MARK: Parsing Helpers
    
    private func parseConnections() {
        guard let dict = self.metadata?[Constants.ConnectionsKey] as? [String: Any] else {
            return
        }
     
        self.connections = [String: Any]()
        for (key, value) in dict {
            if let valueDict = value as? [String: Any] {
                self.connections?[key] = VIMConnection(keyValueDictionary: valueDict)
            }
        }
    }
    
}
