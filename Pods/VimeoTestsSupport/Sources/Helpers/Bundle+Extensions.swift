//
//  Bundle+Extensions.swift
//  VimeoTestsSupport
//
//  Created by Rogerio de Paula Assis on 6/2/19.
//  Copyright © 2019 Vimeo. All rights reserved.
//

import Foundation

class VimeoTestsSupport {}

extension Bundle {
    static var testBundle: Bundle = Bundle(for: VimeoTestsSupport.self)
}
