//
//  ModelObjectValidationTests.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Huebner, Rob on 5/17/16.
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

import XCTest
@testable import VimeoNetworkingExample_iOS

class ModelObjectValidationTests: XCTestCase
{
    func testValidVideoPassesValidation()
    {
        let video = VIMVideo()
        
        video.uri = "/videos/1234567"
        video.resourceKey = "1234567:abcdef"
        
        do
        {
            try video.validateModel()
        }
        catch let error as NSError
        {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testVideoWithNilURIFailsValidation()
    {
        let video = VIMVideo()
        
        video.uri = nil
        video.resourceKey = "1234567:abcdef"
        
        do
        {
            try video.validateModel()
            
            XCTFail("Video with nil URI should have failed validation")
        }
        catch let error as NSError
        {
            XCTAssertEqual(error.code, VIMModelObjectValidationErrorCode)
        }
    }
    
    func testVideoWithNilResourceKeyFailsValidation()
    {
        let video = VIMVideo()
        
        video.uri = "/videos/1234567"
        video.resourceKey = nil
        
        do
        {
            try video.validateModel()
            
            XCTFail("Video with nil resourceKey should have failed validation")
        }
        catch let error as NSError
        {
            XCTAssertEqual(error.code, VIMModelObjectValidationErrorCode)
        }
    }
    
    func testValidUserPassesValidation()
    {
        let user = VIMUser()
        
        user.uri = "/users/1234567"
        
        do
        {
            try user.validateModel()
        }
        catch let error as NSError
        {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testUserWithNilURIFailsValidation()
    {
        let user = VIMUser()
        
        user.uri = nil
        
        do
        {
            try user.validateModel()
            
            XCTFail("User with nil URI should have failed validation")
        }
        catch let error as NSError
        {
            XCTAssertEqual(error.code, VIMModelObjectValidationErrorCode)
        }
    }
    
    // MARK - Helper Method For Cinema testing
    func cinemaEndpointDataSource() -> FakeDataSource<VIMProgrammedContent>
    {
        let jsonFilePath = Bundle(for: type(of: self)).path(forResource: "programmed_cinema", ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonFilePath!))
        let jsonDict = try! JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.allowFragments)
        
        return FakeDataSource<VIMProgrammedContent>(jsonData: jsonDict as! [String : AnyObject], keyPath: "data")
    }
    
    func testProgrammedContentMapped()
    {
        let fakeDS = self.cinemaEndpointDataSource()
     
        // If the JSON data was mapped correctly we should have 6 VIMProgrammedContent objects in our items array
        XCTAssertTrue(fakeDS.items!.count == 6)
    }
    
    func testProgrammedContentObjectsPropertiesAreValid()
    {
        let fakeDS = self.cinemaEndpointDataSource()
        
        //The first item in our list should represent the Travel category
        let travel = fakeDS.items![0]
        XCTAssertNotNil(travel)
        
        XCTAssertEqual(travel.name, "Travel")
        XCTAssertEqual(travel.type, "category")
        XCTAssertEqual(travel.uri, "/categories/travel")
        XCTAssertTrue(travel.content?.count == 5)
        
        //The last item in our list should be the documentary category
        let documentary = fakeDS.items![5]
        XCTAssertNotNil(documentary)
        
        XCTAssertEqual(documentary.name, "Documentary")
        XCTAssertEqual(documentary.type, "category")
        XCTAssertEqual(documentary.uri, "/categories/documentary")
        XCTAssertTrue(documentary.content?.count == 5)
        
        //Every item in the list should be of type category and should contain 5 objects in it's content array
        for programmedContent in fakeDS.items!
        {
            XCTAssertEqual(programmedContent.type, "category")
            XCTAssertTrue(programmedContent.content?.count == 5)
        }
    }
    
    func testProgrammedContentObjectsContainVIMVideoObjects()
    {
        let fakeDS = self.cinemaEndpointDataSource()
        guard let programmedContentItems = fakeDS.items else
        {
            XCTFail("Failed to parse data")
            return
        }
        
        for programmedContent in programmedContentItems
        {
            for video in programmedContent.content!
            {
                XCTAssertTrue(video.isKindOfClass(VIMVideo.self))
                
                XCTAssertNotNil(video.uri)
                XCTAssertNotNil(video.videoDescription)
                XCTAssertNotNil(video.files)
                XCTAssertNotNil(video.resourceKey)
            }
        }
    }
    
    func testProgrammedContentObjectConnections()
    {
        let fakeDS = self.cinemaEndpointDataSource()
        guard let programmedContentItems = fakeDS.items else
        {
            XCTFail("Failed to parse data")
            return
        }
        
        for programmedContent in programmedContentItems
        {
            XCTAssertNotNil(programmedContent.connectionWithName(VIMConnectionNameContents))
        }
    }
    
}
