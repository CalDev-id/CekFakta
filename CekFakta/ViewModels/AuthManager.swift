//
//  AuthManager.swift
//  CekFakta
//
//  Created by Heical Chandra on 18/12/25.
//

import Foundation
import SwiftUI

@MainActor
class AuthManager: ObservableObject {

    @Published var isAuthenticated: Bool = false
    @Published var userEmail: String?
    @Published var isLoading: Bool = true
    @Published var userName: String?
    @Published var avatarURL: String?

    private let baseURL = "http://192.168.50.110:8000"

    init() {
        loadSession()
    }

    // - LOGIN
    func login(email: String, password: String) async throws {
        let url = URL(string: "\(baseURL)/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONEncoder().encode([
            "email": email,
            "password": password
        ])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(AuthResponse.self, from: data)

        Keychain.save("access_token", result.access_token)
        Keychain.save("refresh_token", result.refresh_token)

        userEmail = result.user.email
        isAuthenticated = true
        await fetchCurrentUser()
    }

    // - SIGNUP
    func signup(email: String, password: String, name: String) async throws {
        let url = URL(string: "\(baseURL)/auth/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try JSONEncoder().encode([
            "email": email,
            "password": password,
            "name": name
        ])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        _ = try JSONDecoder().decode(SignUpResponse.self, from: data)
    }


    // - LOGOUT
    func logout() {
        Keychain.delete("access_token")
        Keychain.delete("refresh_token")
        isAuthenticated = false
        userEmail = nil
    }

    // - LOAD SESSION
    func loadSession() {
        Task {
            defer { isLoading = false }

            guard Keychain.load("access_token") != nil else {
                isAuthenticated = false
                return
            }

            await fetchCurrentUser()
        }
    }


    // - AUTH HEADER
    func authHeader() -> String? {
        guard let token = Keychain.load("access_token") else { return nil }
        return "Bearer \(token)"
    }
    
    func fetchCurrentUser() async {
        guard let token = Keychain.load("access_token") else {
            logout()
            return
        }

        let success = await fetchUser(with: token)
        if !success {
            let refreshed = await refreshAccessToken()
            if refreshed {
                _ = await fetchUser(with: Keychain.load("access_token")!)
            }
        }
    }

    private func fetchUser(with token: String) async -> Bool {
        let url = URL(string: "\(baseURL)/auth/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return false
            }

            let user = try JSONDecoder().decode(User.self, from: data)

            self.userEmail = user.email
            self.userName = user.name
            self.avatarURL = user.avatar_url
            self.isAuthenticated = true
            return true
        } catch {
            return false
        }
    }

    func refreshAccessToken() async -> Bool {
        guard let refreshToken = Keychain.load("refresh_token") else { return false }

        let url = URL(string: "\(baseURL)/auth/refresh")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONEncoder().encode([
            "refresh_token": refreshToken
        ])

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                logout()
                return false
            }

            let result = try JSONDecoder().decode(RefreshResponse.self, from: data)
            Keychain.save("access_token", result.access_token)
            return true

        } catch {
            logout()
            return false
        }
    }
    
    // - UPDATE PROFILE
    func updateProfile(
        name: String? = nil,
        avatarURL: String? = nil,
        email: String? = nil,
        password: String? = nil
    ) async throws {

        guard let token = Keychain.load("access_token") else {
            throw URLError(.userAuthenticationRequired)
        }

        let url = URL(string: "\(baseURL)/profile")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let body = UpdateProfileRequest(
            name: name,
            avatar_url: avatarURL,
            email: email,
            password: password
        )

        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        await fetchCurrentUser()
    }
    
    func uploadAvatar(_ image: UIImage) async throws -> String {
        guard let data = image.jpegData(compressionQuality: 0.8),
              let token = Keychain.load("access_token") else {
            throw URLError(.userAuthenticationRequired)
        }

        let fileName = UUID().uuidString + ".jpg"
        let url = URL(string: "\(baseURL)/profile/avatar")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpBody = MultipartFormData.build(
            boundary: boundary,
            data: data,
            fileName: fileName
        )

        let (responseData, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse, http.statusCode != 200 {
            let error = String(data: responseData, encoding: .utf8) ?? ""
            print("UPLOAD ERROR:", error)
            throw URLError(.badServerResponse)
        }

        let result = try JSONDecoder().decode(UploadResponse.self, from: responseData)
        return result.avatar_url
    }


}

