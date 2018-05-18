//
//  Console.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 02.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

struct Console {

    static func write(error: AppError) {
        write(message: error.message)
    }

    static func write(message: String) {
        guard let messageData = "\(message)\n".data(using: .utf8) else { return }
        FileHandle.standardOutput.write(messageData)
    }
}

struct Log {
    static var shared: Log = Log()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "DD/MM/YYYY hh:mm:ss"
        return formatter
    }()

    private init() {
        // create log file
    }

    func write(message: String) {
        Console.write(message: "------ \(self.currentTime): \(message)")
    }

    private var currentTime: String {
        return timeFormatter.string(from: Date())
    }
}
