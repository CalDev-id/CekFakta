//
//  ChatModel.swift
//  CekFakta
//
//  Created by Heical Chandra on 27/11/25.
//

import Foundation

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let role: String      // "user" atau "assistant"
    let content: String
}

struct ChatRequest: Codable {
    let message: String
}

struct ChatResponse: Codable {
    let response: String?
    let error: String?
}
