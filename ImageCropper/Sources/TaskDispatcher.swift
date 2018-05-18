//
//  TaskDispatcher.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 04.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import Dispatch

struct TaskDispatcher {
    private let queue: OperationQueue

    init(simultaneousTasks: Int) {
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = simultaneousTasks
        queue.qualityOfService            = .userInteractive
        queue.underlyingQueue             = DispatchQueue(
            label: "image.cropper.task.queue",
            qos: .userInteractive,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit)
    }

    func run(_ task: @escaping () -> Void) {
        queue.addOperation(task)
    }

    func waitForAll() {
        queue.waitUntilAllOperationsAreFinished()
    }
}
