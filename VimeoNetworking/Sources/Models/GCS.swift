//
//  GCS.swift
//  Pods
//
//  Created by Nguyen, Van on 11/8/18.
//

public class GCS: VIMModelObject
{
    public enum Connection: String
    {
        case uploadAttempt = "upload_attempt"
    }
    
    @objc public private(set) var startByte: NSNumber?
    @objc public private(set) var endByte: NSNumber?
    @objc public private(set) var uploadLink: String?
    @objc internal private(set) var metadata: [String: Any]?
    
    public private(set) var connections = [Connection: VIMConnection]()
    
    override public func didFinishMapping()
    {
        guard let metadata = self.metadata, let connections = metadata["connections"] as? [String: Any] else
        {
            return
        }
        
        let uploadAttemptDict = connections[Connection.uploadAttempt.rawValue] as? [String: Any]
        let uploadAttemptConnection = VIMConnection(keyValueDictionary: uploadAttemptDict)
        
        self.connections[.uploadAttempt] = uploadAttemptConnection
    }
}
