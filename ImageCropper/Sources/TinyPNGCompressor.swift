//
//  ImageUploader.swift
//  ImageCropper
//
//  Created by Oleg Ketrar on 03.09.17.
//  Copyright © 2017 Oleg Ketrar. All rights reserved.
//

import Foundation
import Dispatch

/// Upload Image to TinyPNG Server, compress it, and download back.
struct TinyPNGCompressor {
    private let apiKey: String
    private let tinyPngUrl = "https://api.tinify.com/shrink"
    private let semaphore  = DispatchSemaphore(value: 0)

    init(apiKey: String) {
        self.apiKey = apiKey
    }
}

extension TinyPNGCompressor {
    func compress(image: Image) throws -> Data {
        let uploadRequest = try buildUploadRequest()
        let inputData     = try image.data()
        let receivedData  = try send(data: inputData, with: uploadRequest)
        let imageUrl      = try parseImageUrl(from: receivedData)

        return try downloadData(at: imageUrl)
    }

    private func downloadData(at url: URL) throws -> Data {

        var responseError: String?
        var responseData: Data?

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.semaphore.signal() }

            guard error == nil else {
                responseError = error?.localizedDescription
                return
            }

            guard let receivedData = data else {
                responseError = "Can't get received data from \(url.absoluteString)"
                return
            }

            responseData = receivedData
        }

        task.resume()
        semaphore.wait()

        guard let data = responseData else {
            throw AppError(responseError ?? "Can't download image from \(url.absoluteString)")
        }

        return data
    }

    private func parseImageUrl(from data: Data) throws -> URL {
        guard let obj  = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
            let outObj = obj["output"] as? [String:Any],
            let urlStr = outObj["url"] as? String else { throw AppError("Can't parse json from TinyPNG server") }

        guard let url = URL(string: urlStr) else {
            throw AppError("Can't create URL from \(urlStr)")
        }

        return url
    }

    private func send(data uploadData: Data, with request: URLRequest) throws -> Data {

        var responseError: String?
        var responseData: Data?

        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
            defer { self.semaphore.signal() }

            guard error == nil else {
                responseError = error?.localizedDescription
                return
            }

            guard let receivedData = data else {
                responseError = "Can't get received data from TinyPNG Server"
                return
            }

            responseData = receivedData
        }

        task.resume()
        semaphore.wait()

        guard let data = responseData else {
            throw AppError(responseError ?? "Can't upload image to TinyPNG")
        }

        return data
    }

    private func buildUploadRequest() throws -> URLRequest {
        guard let serviceUrl = URL(string: tinyPngUrl) else {
            throw AppError("Can't create URL of TinyPNG Service")
        }

        var request = URLRequest(url: serviceUrl)
        request.cachePolicy             = .reloadIgnoringLocalAndRemoteCacheData
        request.httpShouldHandleCookies = false
        request.timeoutInterval         = 120
        request.httpMethod              = "POST"

        request.addValue("Basic \(try credentials())", forHTTPHeaderField: "Authorization")

        return request
    }

    private func credentials() throws -> String {
        guard let data = "api:\(apiKey)".data(using: .utf8, allowLossyConversion: false) else {
            throw AppError("Can't encode credentials with UTF8")
        }

        return data.base64EncodedString()
    }
}
