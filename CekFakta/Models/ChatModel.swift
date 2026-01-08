//
//  ChatModel.swift
//  CekFakta
//
//  Created by Heical Chandra on 27/11/25.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let role: String
    let content: String
    let createdAt: Date

    init(id: UUID = UUID(), role: String, content: String, createdAt: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.createdAt = createdAt
    }
}


struct ChatRequest: Codable {
    let message: String
}

struct ChatResponse: Codable {
    let response: String?
    let error: String?
}
