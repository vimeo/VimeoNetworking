//
//  GCS.swift
//  Pods
//
//  Created by Nguyen, Van on 11/8/18.
//

public class GCS: VIMModelObject
{
    public private(set) var startByte: NSNumber?
    public private(set) var endByte: NSNumber?
    public private(set) var uploadLink: String?
    public private(set) var metadata: [String: Any]?
}
