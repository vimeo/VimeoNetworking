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
