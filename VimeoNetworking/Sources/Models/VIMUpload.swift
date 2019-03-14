//
//  VIMUpload.swift
//  Pods
//
//  Created by Lehrer, Nicole on 4/18/18.
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

/// Encapsulates the upload-related information on a video object.
public class VIMUpload: VIMModelObject {
    /// The approach for uploading the video, expressed as a Swift-only enum
    ///
    /// - streaming: Two-step upload without using tus; this will be deprecated
    /// - post: Upload with an HTML form or POST
    /// - pull: Upload from a video file that already exists on the internet
    /// - tus: Upload using the open-source tus protocol
    public struct UploadApproach: RawRepresentable, Equatable {
        public typealias RawValue = String
        
        public init?(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public var rawValue: String
        
        public static let Streaming = UploadApproach(rawValue: "streaming")!
        public static let Post = UploadApproach(rawValue: "post")!
        public static let Pull = UploadApproach(rawValue: "pull")!
        public static let Tus = UploadApproach(rawValue: "tus")!
    }
    
    /// The status code for the availability of the uploaded video, expressed as a Swift-only enum
    ///
    /// - complete: The upload is complete
    /// - error: The upload ended with an error
    /// - underway: The upload is in progress
    public enum UploadStatus: String {
        case complete
        case error
        case inProgress = "in_progress"
    }
    
    /// The approach for uploading the video
    @objc dynamic public private(set) var approach: String?

    /// The file size in bytes of the uploaded video
    @objc dynamic public private(set) var size: NSNumber?

    /// The status code for the availability of the uploaded video
    @objc dynamic public private(set) var status: String?
    
    /// The HTML form for uploading a video through the post approach
    @objc dynamic public private(set) var form: String?
    
    /// The link of the video to capture through the pull approach
    @objc dynamic public private(set) var link: String?

    /// The URI for completing the upload
    @objc dynamic public private(set) var completeURI: String?
    
    /// The redirect URL for the upload app
    @objc dynamic public private(set) var redirectURL: String?

    /// The link for sending video file data
    @objc dynamic public private(set) var uploadLink: String?
    
    /// The approach for uploading the video, mapped to a Swift-only enum
    public private(set) var uploadApproach: UploadApproach?
    
    /// The status code for the availability of the uploaded video, mapped to a Swift-only enum
    public private(set) var uploadStatus: UploadStatus?
    
    public private(set) var gcs: [GCS]?
    
    @objc internal private(set) var gcsStorage: NSArray?
    
    // MARK: - VIMMappable Protocol Conformance
    
    /// Called when automatic object mapping completes
    public override func didFinishMapping() {
        if let approachString = self.approach {
            self.uploadApproach = UploadApproach(rawValue: approachString)
        }
        
        if let statusString = self.status {
            self.uploadStatus = UploadStatus(rawValue: statusString)
        }
        
        self.gcs = [GCS]()
        
        self.gcsStorage?.forEach({ (object) in
            guard let dictionary = object as? [String: Any], let gcsObject = try? VIMObjectMapper.mapObject(responseDictionary: dictionary) as GCS else {
                return
            }
            
            self.gcs?.append(gcsObject)
        })
    }
    
    /// Maps the property name that mirrors the literal JSON response to another property name.
    /// Typically used to rename a property to one that follows this project's naming conventions.
    ///
    /// - Returns: A dictionary where the keys are the JSON response names and the values are the new property names.
    public override func getObjectMapping() -> Any {
        return ["complete_uri": "completeURI", "redirect_url": "redirectURL", "gcs": "gcsStorage"]
    }
}
