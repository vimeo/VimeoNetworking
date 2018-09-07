//
//  Spatial.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/6/17.
//
//
//

/// Spatial stores all information related to threesixty video
public class Spatial: VIMModelObject
{
    @objc public static let StereoFormatMono = "mono"
    @objc public static let StereoFormatLeftRight = "left-right"
    @objc public static let StereoFormatTopBottom = "top-bottom"
    
    /// Represents the projection. Value returned by the server can be: "equirectangular", "cylindrical", "cubical", "pyramid", "dome".
    @objc dynamic public private(set) var projection: String?
    
    /// Represents the format. Value returned by the server can be: "mono", "left-right", "top-bottom"
    @objc dynamic public private(set) var stereoFormat: String?
    
    // MARK: - VIMMappable
    
    public override func getObjectMapping() -> Any
    {
        return ["stereo_format" : "stereoFormat"]
    }
}
