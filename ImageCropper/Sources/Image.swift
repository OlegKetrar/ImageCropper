//
//  Image.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 03.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import CoreGraphics

struct Image {
    let name: String
    var image: CGImage
}

extension Image {
    func applying(_ transform: (CGImage) throws -> CGImage) rethrows -> Image {
        var copy = self
        copy.image = try transform(image)

        return copy
    }

    func data() throws -> Data {
        guard let imageData = CFDataCreateMutable(nil, 0) else {
            throw AppError("Can't allocate CFMutableData")
        }

        guard let destination = CGImageDestinationCreateWithData(imageData, kUTTypePNG, 1, nil) else {
            throw AppError("Can't create CGImageDestination")
        }
        
        CGImageDestinationAddImage(destination, image, nil)

        guard CGImageDestinationFinalize(destination) else {
            throw AppError("Can't write CGImage to CGImageDestination")
        }

        return imageData as Data
    }
}

extension Image: CustomStringConvertible {
    var description: String {
        let colorSpaceStr: String = {
            guard let colorSpace = image.colorSpace else { return "nil" }
            return "\(colorSpace)"
        }()

        return """
        \(name):
        size: \(image.width) x \(image.height)
        color: \(colorSpaceStr)
        shouldInterpolate: \(image.shouldInterpolate)
        bitmapInfo: \(image.bitmapInfo)
        """
    }
}
