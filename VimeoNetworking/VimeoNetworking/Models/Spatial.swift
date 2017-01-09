//
//  Spatial.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/6/17.
//
//
//

public class Spatial: VIMModelObject
{
    enum Projection: String
    {
        case Equirectangular = "equirectangular"
        case Cylindrical = "cylindrical"
        case Cubical = "cubical"
        case Pyramid = "pyramid"
        case Dome = "dome"
    }
    
    enum Format: String
    {
        case Mono = "mono"
        case LeftRight = "left-right"
        case TopBottom = "top-bottom"
    }
    
    // MARK: - Properties
    
    // TODO: - Update to be Projection, Format types
    public dynamic var projection: String?
    public dynamic var stereoFormat: String?
    
    // MARK: - VIMMappable
    
    public override func getObjectMapping() -> AnyObject!
    {
        return ["stereo_format" : "stereoFormat"]
    }
}
