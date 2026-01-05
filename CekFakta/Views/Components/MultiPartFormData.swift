//
//  MultiPartFormData.swift
//  CekFakta
//
//  Created by Heical Chandra on 19/12/25.
//

import Foundation

enum MultipartFormData {

    static func build(
        boundary: String,
        data: Data,
        fileName: String,
        fieldName: String = "file",
        mimeType: String = "image/jpeg"
    ) -> Data {

        var body = Data()

        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        return body
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
