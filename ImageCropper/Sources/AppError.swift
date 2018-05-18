//
//  AppError.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 01.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

struct AppError: Swift.Error {
    let message: String

    init(_ msg: String) {
        message = msg
    }
}
