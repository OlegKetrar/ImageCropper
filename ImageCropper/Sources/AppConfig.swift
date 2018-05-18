//
//  AppConfig.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 04.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

struct AppConfig {
    private struct Key {
        static let tinyPngApiKey = "tinyPngApiKey"
    }

    let tinyPNGApiKey: String

    init(filePath: String) throws {
        let fileData = try Data(contentsOf: URL(fileURLWithPath: filePath))

        guard !fileData.isEmpty else {
            throw AppError("Can't read config at \(filePath)")
        }

        let plist = try PropertyListSerialization.propertyList(
            from: fileData,
            options: [],
            format: nil)

        guard let plistObj = plist as? [String:Any] else {
            throw AppError("Can't parse config at \(filePath)")
        }

        guard let apiKey = plistObj[Key.tinyPngApiKey] as? String else {
            throw AppError("Can't parse \(Key.tinyPngApiKey) from \(filePath)")
        }

        tinyPNGApiKey = apiKey
    }
}
