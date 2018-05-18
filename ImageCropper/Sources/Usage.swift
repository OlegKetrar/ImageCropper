//
//  Usage.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 02.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

struct Usage: CustomStringConvertible {
    private let appName: String
    init(of app: String) { appName = app }
    
    var description: String {
        return """
        Usage of \(appName):
        ./\(appName) [input_image_folder_path] [output_image_folder_path]
        """
    }
}
