//
//  Request+Picture.swift
//  Pods
//
//  Created by King, Gavin on 10/24/16.
//
//

public extension Request {
    /// `Request` that returns a single `VIMPicture`
    typealias PictureRequest = Request<VIMPicture>
    
    /**
     Create a `Request` to create a picture for a user
     
     - parameter userURI: the URI of the user
     
     - returns: a new `Request`
     */
    static func createPictureRequest(forUserURI userURI: String) -> Request {
        let uri = "\(userURI)/pictures"
        
        return Request(method: .post, path: uri)
    }

    /**
     Create a `Request` to create a picture for a video. Note that if `time` is not specified then `active` will have
     no effect.

     - parameter videoURI: the URI of the video
     - parameter time: the timestamp (in seconds) of the point in the video that the thumbnail should reflect
     - parameter active: whether the newly created thumbnail should be activated

     - returns: a new `Request`
     */
    static func createPictureRequest(
        forVideoURI videoURI: String,
        time: TimeInterval? = nil,
        active: Bool? = nil) -> Request {
        let uri = "\(videoURI)/pictures"

        
        var parameters: VimeoClient.RequestParametersDictionary = [:]
        parameters[.timeKey] = time
        parameters[.activeKey] = active

        return Request(method: .post, path: uri, parameters: parameters)
    }
    
    /**
     Create a `Request` to delete a picture
     
     - parameter pictureURI: the URI of the picture
     
     - returns: a new `Request`
     */
    static func deletePictureRequest(forPictureURI pictureURI: String) -> Request {
        return Request(method: .delete, path: pictureURI)
    }
    
    /**
     Create a `Request` to activate a picture
     
     - parameter pictureURI: the URI of the picture
     
     - returns: a new `Request`
     */
    static func activatePictureRequest(forPictureURI pictureURI: String) -> Request {
        let parameters = ["active": "true"]
        
        return Request(method: .patch, path: pictureURI, parameters: parameters)
    }
}

private extension String {
    // Request & response keys
    static let timeKey = "time"
    static let activeKey = "active"
}
