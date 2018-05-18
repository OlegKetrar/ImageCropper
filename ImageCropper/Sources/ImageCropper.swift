//
//  ImageCropper.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 01.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import CoreGraphics

struct ImageCropper {
    enum Mode {
        case transparentPixels
        case fixedInsets(NSEdgeInsets)
    }

    let mode: Mode
}

extension ImageCropper {

    func crop(image: Image) throws -> Image {
        let croppedInsets: NSEdgeInsets = try {
            guard case let .fixedInsets(insets) = mode else { return try transparentInsets(of: image.image) }
            return insets
            }()

        return try image.applying {
            try crop(insets: croppedInsets, from: $0)
        }
    }

    private func crop(insets: NSEdgeInsets, from image: CGImage) throws -> CGImage {
        guard !insets.isEmpty else { return image }

        // get image rect
        var imageRect = CGRect(origin: .zero, size: image.size)

        // calculate new crop bounds
        imageRect.origin.x    += insets.left
        imageRect.origin.y    += insets.top
        imageRect.size.width  -= insets.left + insets.right
        imageRect.size.height -= insets.top + insets.bottom

        guard let cropped = image.cropping(to: imageRect) else {
            throw AppError("Can't crop image to \(imageRect)")
        }

        return cropped
    }

    private func transparentInsets(of image: CGImage) throws -> NSEdgeInsets {
        var bitmapArray: [UInt8] = Array<UInt8>(repeating: 0, count: image.bytesPerRow * image.height)

        let context = CGContext(
            data: &bitmapArray,
            width: image.width,
            height: image.height,
            bitsPerComponent: image.bitsPerComponent,
            bytesPerRow: image.bytesPerRow,
            space: image.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)

        context?.draw(image, in: CGRect(origin: .zero, size: image.size))

        //
        var rowSum: [UInt16] = Array<UInt16>(repeating: 0, count: image.height)
        var colSum: [UInt16] = Array<UInt16>(repeating: 0, count: image.width)

        //
        for row in 0..<image.height {
            for col in 0..<image.width {
                let alphaIndex = row * image.bytesPerRow + (col + 1) * 4 - 1

                if bitmapArray[alphaIndex] > 0 { // first non transparent pixel
                    rowSum[row] += 1
                    colSum[col] += 1
                }
            }
        }

        //
        var croppedInsets = NSEdgeInsets()

        for i in 0..<image.height { // top
            if rowSum[i] > 0 {
                croppedInsets.top = CGFloat(i)
                break
            }
        }

        for i in (0..<image.height).reversed() { // bottom
            if rowSum[i] > 0 {
                croppedInsets.bottom = CGFloat(max(0, image.height - i - 1))
                break
            }
        }

        for i in 0..<image.width { // left
            if colSum[i] > 0 {
                croppedInsets.left = CGFloat(i)
                break
            }
        }

        for i in (0..<image.width).reversed() { // right
            if colSum[i] > 0 {
                croppedInsets.right = CGFloat(max(0, image.width - i - 1))
                break
            }
        }

        return croppedInsets
    }
}
