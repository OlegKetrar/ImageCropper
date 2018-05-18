//
//  ImageWriter.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 03.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import CoreGraphics
import AppKit

struct ImageWriter {
    let path: String
}

extension ImageWriter {
    func write(image: Image) throws {
        guard let destination = CGImageDestinationCreateWithURL(
            URL(fileURLWithPath: path) as NSURL,
            image.image.utType ?? kUTTypePNG,
            1,
            nil) else { throw AppError("Can't create CGImageDestination") }
        
        CGImageDestinationAddImage(destination, image.image, [
            kCGImageDestinationLossyCompressionQuality : NSNumber(value: 0.0),
            kCGImagePropertyHasAlpha : NSNumber(value: true)
            ] as NSDictionary)
        
        guard CGImageDestinationFinalize(destination) else {
            throw AppError("Can't finalize CGImageDestination")
        }
    }
    
    func write(data: Data) throws {
        try data.write(to: URL(fileURLWithPath: path))
    }
}
