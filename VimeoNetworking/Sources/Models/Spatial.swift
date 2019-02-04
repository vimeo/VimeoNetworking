//
//  Spatial.swift
//  Pods
//
//  Created by Lim, Jennifer on 1/6/17.
//  Copyright (c) 2014-2018 Vimeo (https://vimeo.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/// Spatial stores all information related to threesixty video
public class Spatial: VIMModelObject {
    @objc public static let StereoFormatMono = "mono"
    @objc public static let StereoFormatLeftRight = "left-right"
    @objc public static let StereoFormatTopBottom = "top-bottom"
    
    /// Represents the projection. Value returned by the server can be: "equirectangular", "cylindrical", "cubical", "pyramid", "dome".
    @objc dynamic public private(set) var projection: String?
    
    /// Represents the format. Value returned by the server can be: "mono", "left-right", "top-bottom"
    @objc dynamic public private(set) var stereoFormat: String?
    
    // MARK: - VIMMappable
    
    public override func getObjectMapping() -> Any {
        return ["stereo_format" : "stereoFormat"]
    }
}
