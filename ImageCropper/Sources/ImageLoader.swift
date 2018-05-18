//
//  ImageLoader.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 01.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import CoreGraphics

struct ImageLoader {
    private init() {}
}

extension ImageLoader {

    static func from(filePath: String) throws -> Image {
        guard let provider = CGDataProvider(url: URL(fileURLWithPath: filePath) as NSURL) else {
            throw AppError("Can't read data from \(filePath)")
        }

        guard let rawImage = CGImage(
            pngDataProviderSource: provider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent) else { throw AppError("Can't create CGImage from data") }

        return Image(
            name: (filePath as NSString).lastPathComponent,
            image: rawImage)
    }

    /*
     static func from(data: Data) throws -> Image {
     guard let provider = CGDataProvider(data: data as NSData) else {
     throw AppError("Can't create CGDataProvider with Data")
     }

     guard let rawImage = CGImage(
     pngDataProviderSource: provider,
     decode: nil,
     shouldInterpolate: false,
     intent: .defaultIntent) else { throw AppError("Can't create CGImage from data") }

     return Image(
     name: UUID().uuidString,
     image: rawImage)
     }

     private static func loadWithURL(_ url: URL) throws -> CGImage {
     guard let provider = CGDataProvider(url: url as NSURL) else {
     throw AppError("Can't read data from \(url.absoluteString)")
     }

     guard let rawImage = CGImage(
     pngDataProviderSource: provider,
     decode: nil,
     shouldInterpolate: false,
     intent: .defaultIntent) else { throw AppError("Can't create CGImage from data") }

     return rawImage
     }
     */
}
