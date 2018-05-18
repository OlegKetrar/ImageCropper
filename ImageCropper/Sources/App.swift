//
//  App.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 02.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import CoreGraphics

private let configName = "config.plist"


struct DirectoryInfo {
    private init() {}

    static func filePaths(at directoryPath: String) throws -> [String] {
        return try FileManager.default
            .contentsOfDirectory(atPath: directoryPath)
            .map { (directoryPath as NSString).appendingPathComponent($0) }
    }
}

struct App {
    private let inputPath: String
    private let outputPath: String
    private let config: AppConfig

    init(arguments: [String]) throws {
        guard let executablePath = arguments.first else {
            throw AppError("Can't find path of executable")
        }

        let executableDir = (executablePath as NSString).deletingLastPathComponent
        let configPath    = (executableDir as NSString).appendingPathComponent(configName)

        guard arguments.count == 3 else {
            let appName = (executablePath as NSString).lastPathComponent
            throw AppError(Usage(of: appName).description)
        }

        config     = try AppConfig(filePath: configPath)
        inputPath  = arguments[1]
        outputPath = arguments[2]
    }

    func run() throws {
        let dispatcher = TaskDispatcher(simultaneousTasks: 50)

        // create task and add to dispatcher
        try DirectoryInfo.filePaths(at: inputPath).forEach { (filePath) in

            dispatcher.run {
                do {
                    let source     = try ImageLoader.from(filePath: filePath)
                    let cropped    = try ImageCropper(mode: .transparentPixels).crop(image: source)
                    let compressed = try TinyPNGCompressor(apiKey: self.config.tinyPNGApiKey).compress(image: cropped)

                    try ImageWriter(path: self.outputPath + "/\(source.name)").write(data: compressed)

                    // write ok
                    Console.write(message: "\(filePath) - success")

                } catch let error {
                    Console.write(message: "\(filePath) - failure")

                    Log.shared.write(message: {
                        let errorMsg = (error as? AppError)?.message ?? error.localizedDescription
                        return "\(filePath) - failure \nerror: \(errorMsg)"
                    }())
                }
            }
        }

        dispatcher.waitForAll()
    }
}
