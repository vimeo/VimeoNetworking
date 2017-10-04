//
//  VIMLiveHeartbeat.swift
//  Pods
//
//  Created by Nguyen, Van on 10/4/17.
//
//

import Foundation

class VIMLiveHeartbeat: VIMModelObject
{
    private struct Constants
    {
        static let HeartbeatUrlKey = "heartbeat"
    }
    
    private(set) var heartbeatUrl: String?
    
    override func getObjectMapping() -> Any?
    {
        return [Constants.HeartbeatUrlKey: "heartbeatUrl"]
    }
}
