//
//  VIMUploadTests.swift
//  VimeoNetworkingExample-iOS
//
//  Created by Lehrer, Nicole on 5/1/18.
//  Copyright © 2018 Vimeo. All rights reserved.
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
@testable import VimeoNetworking

class VIMUploadTests: XCTestCase
{
    func test_didFinishMapping_createsUploadApproach()
    {
        var uploadDictionary: [String: Any] = ["approach": "streaming"]
        var uploadObject = VIMUpload(keyValueDictionary: uploadDictionary)!
        uploadObject.didFinishMapping()
        XCTAssertTrue(uploadObject.uploadApproach == VIMUpload.UploadApproach.Streaming, "VIMUpload did not correctly map raw value to Swift enum UploadApproach.")
       
        uploadDictionary = ["approach": "post"]
        uploadObject = VIMUpload(keyValueDictionary: uploadDictionary)!
        uploadObject.didFinishMapping()
        XCTAssertTrue(uploadObject.uploadApproach == VIMUpload.UploadApproach.Post, "VIMUpload did not correctly map raw value to Swift enum UploadApproach.")

        uploadDictionary = ["approach": "pull"]
        uploadObject = VIMUpload(keyValueDictionary: uploadDictionary)!
        uploadObject.didFinishMapping()
        XCTAssertTrue(uploadObject.uploadApproach == VIMUpload.UploadApproach.Pull, "VIMUpload did not correctly map raw value to Swift enum UploadApproach.")

        uploadDictionary = ["approach": "tus"]
        uploadObject = VIMUpload(keyValueDictionary: uploadDictionary)!
        uploadObject.didFinishMapping()
        XCTAssertTrue(uploadObject.uploadApproach == VIMUpload.UploadApproach.Tus, "VIMUpload did not correctly map raw value to Swift enum UploadApproach.")
    }
    
    func test_didFinishMapping_createsUploadStatus()
    {
        var uploadDictionary: [String: Any] = ["status": "complete"]
        var uploadObject = VIMUpload(keyValueDictionary: uploadDictionary)!
        uploadObject.didFinishMapping()
        XCTAssertTrue(uploadObject.uploadStatus == .complete, "VIMUpload did not correctly map raw value to Swift enum UploadStatus.")
        
        uploadDictionary = ["status": "error"]
        uploadObject = VIMUpload(keyValueDictionary: uploadDictionary)!
        uploadObject.didFinishMapping()
        XCTAssertTrue(uploadObject.uploadStatus == .error, "VIMUpload did not correctly map raw value to Swift enum UploadStatus.")
        
        uploadDictionary = ["status": "in_progress"]
        uploadObject = VIMUpload(keyValueDictionary: uploadDictionary)!
        uploadObject.didFinishMapping()
        XCTAssertTrue(uploadObject.uploadStatus == .inProgress, "VIMUpload did not correctly map raw value to Swift enum UploadStatus.")
    }
}
