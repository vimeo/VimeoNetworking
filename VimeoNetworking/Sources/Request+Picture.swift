//
//  Request+Picture.swift
//  Pods
//
//  Created by King, Gavin on 10/24/16.
//
//

public extension Request
{
    /// `Request` that returns a single `VIMPicture`
    public typealias PictureRequest = Request<VIMPicture>
    
    /**
     Create a `Request` to create a picture for a user
     
     - parameter userURI: the URI of the user
     
     - returns: a new `Request`
     */
    public static func createPictureRequest(userURI userURI: String) -> Request
    {
        let uri = userURI + "/pictures"
        
        return Request(method: .POST, path: uri)
    }
    
    /**
     Create a `Request` to delete a picture
     
     - parameter pictureURI: the URI of the picture
     
     - returns: a new `Request`
     */
    public static func deletePictureRequest(pictureURI pictureURI: String) -> Request
    {
        return Request(method: .DELETE, path: pictureURI)
    }
    
    /**
     Create a `Request` to activate a picture
     
     - parameter pictureURI: the URI of the picture
     
     - returns: a new `Request`
     */
    public static func activatePictureRequest(pictureURI pictureURI: String) -> Request
    {
        let parameters = ["active": "true"]
        
        return Request(method: .PATCH, path: pictureURI, parameters: parameters)
    }
}