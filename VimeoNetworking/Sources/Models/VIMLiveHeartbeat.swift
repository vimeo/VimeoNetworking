//
//  VIMLiveHeartbeat.swift
//  Pods
//
//  Created by Nguyen, Van on 10/4/17.
//
//

import Foundation

public class VIMLiveHeartbeat: VIMModelObject
{
    private struct Constants
    {
        static let HeartbeatUrlKey = "heartbeat"
    }
    
    public private(set) var heartbeatUrl: String?
    
    override public func getObjectMapping() -> Any?
    {
        return [Constants.HeartbeatUrlKey: "heartbeatUrl"]
    }
}
