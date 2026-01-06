//
//  AuthTokenProvider.swift
//  CekFakta
//
//  Created by Heical Chandra on 06/01/26.
//

import Foundation
import Security

enum AuthTokenProvider {

    static func accessToken() -> String? {
        Keychain.load("access_token")
    }

    static func refreshToken() -> String? {
        Keychain.load("refresh_token")
    }

    static func authHeader() -> String? {
        guard let token = accessToken() else { return nil }
        return "Bearer \(token)"
    }
}
