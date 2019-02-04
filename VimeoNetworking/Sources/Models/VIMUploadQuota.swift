//
//  VIMUploadQuota.swift
//  VimeoNetworking
//
//  Created by Lim, Jennifer on 3/26/18.
//
//  Copyright © 2016 Vimeo. All rights reserved.
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

import Foundation

public class VIMUploadQuota: VIMModelObject {
    /// The values within `VIMSpace` reflect the lowest of lifetime or period for free and max.
    @objc dynamic public private(set) var space: VIMSpace?
    
    /// Represents the current quota period
    @objc dynamic public private(set) var periodic: VIMPeriodic?
    
    /// Represents the lifetime quota period
    @objc dynamic public private(set) var lifetime: VIMSizeQuota?
    
    public override func getClassForObjectKey(_ key: String!) -> AnyClass? {
        if key == "space" {
            return VIMSpace.self
        }
        else if key == "periodic" {
            return VIMPeriodic.self
        }
        else if key == "lifetime" {
            return VIMSizeQuota.self
        }
        
        return nil
    }

    /// Determines whether the user has a periodic storage quota limit or has a lifetime upload quota storage limit only.
    @objc public lazy var isPeriodicQuota: Bool = {
        return self.space?.type == "periodic"
    }()
}
