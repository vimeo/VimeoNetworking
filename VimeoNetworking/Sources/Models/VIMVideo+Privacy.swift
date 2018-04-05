//
//  VIMVideo+Privacy.swift
//  Pods
//
//  Created by Lehrer, Nicole on 4/5/18.
//

public extension VIMVideo
{
    struct Constants
    {
        static let ResponseErrorDomain = "com.vimeo.VimeoNetworking.VIMVideo"
        static let ResponseErrorDescription = "Unexpected response type on video object."
    }
    
    /// Returns a boolean describing if the video can be downloaded from the web on desktop
    ///
    /// - Returns: A boolean describing if the video can be downloaded
    /// - Throws: An error if the type of object does not respond to boolValue
    public func canDownloadOnDesktop() throws -> Bool
    {
        guard let canDownload = self.privacy?.canDownload, canDownload.responds(to: #selector(getter: NSNumber.boolValue)) else
        {
            let error = NSError(domain: Constants.ResponseErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: Constants.ResponseErrorDescription])
            throw error
        }
        
        return canDownload.boolValue
    }
}
