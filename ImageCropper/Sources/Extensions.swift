//
//  CoreImageExtensions.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 02.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import CoreGraphics

extension NSEdgeInsets {

    static var zero: NSEdgeInsets {
        return NSEdgeInsetsZero
    }
    
    var isEmpty: Bool {
        return top == 0 && bottom == 0 && left == 0 && right == 0
    }
}

extension CGImage {
    var size: CGSize {
        return CGSize(width: width, height: height)
    }
}
