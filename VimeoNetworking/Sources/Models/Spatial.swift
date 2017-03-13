//
//  Spatial.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/6/17.
//
//
//

/// Spatial stores all information related to threesixty video
open class Spatial: VIMModelObject
{
    open static let StereoFormatMono = "mono"
    open static let StereoFormatLeftRight = "left-right"
    open static let StereoFormatTopBottom = "top-bottom"
    
    /// Represents the projection. Value returned by the server can be: "equirectangular", "cylindrical", "cubical", "pyramid", "dome".
    open var projection: String?
    
    /// Represents the format. Value returned by the server can be: "mono", "left-right", "top-bottom"
    open var stereoFormat: String?
    
    // MARK: - VIMMappable
    
    open override func getObjectMapping() -> Any
    {
        return ["stereo_format" : "stereoFormat"]
    }
}
