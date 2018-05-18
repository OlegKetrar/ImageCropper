//
//  main.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 01.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation

do {
    try App(arguments: CommandLine.arguments).run()
    exit(EXIT_SUCCESS)

} catch let error as AppError {
    Console.write(error: error)
    exit(EXIT_FAILURE)

} catch let error {
    Console.write(message: error.localizedDescription)
    exit(EXIT_FAILURE)
}
