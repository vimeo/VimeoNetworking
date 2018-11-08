//
//  GCS.swift
//  Pods
//
//  Created by Nguyen, Van on 11/8/18.
//

public class GCS: VIMModelObject
{
    @objc public private(set) var startByte: NSNumber?
    @objc public private(set) var endByte: NSNumber?
    @objc public private(set) var uploadLink: String?
    internal private(set) var metadata: [String: Any]?
}
