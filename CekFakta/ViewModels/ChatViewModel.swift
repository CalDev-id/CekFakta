//
//  ChatViewModel.swift
//  CekFakta
//
//  Created by Heical Chandra on 27/11/25.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var chatHistory: [ChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let baseURL = "http://192.168.50.110:8000/chat"

    func addUserMessage(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let msg = ChatMessage(role: "user", content: text)
        chatHistory.append(msg)
    }

    func sendMessage() {
        guard let lastUserMessage = chatHistory.last(where: { $0.role == "user" }) else { return }
        
        isLoading = true
        errorMessage = nil

        let payload = ChatRequest(message: lastUserMessage.content)
        
        guard let url = URL(string: baseURL) else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(payload)
        } catch {
            self.errorMessage = "Failed to encode data"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No response from server"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(ChatResponse.self, from: data)
                    
                    if let error = decoded.error {
                        self.errorMessage = error
                        return
                    }

                    if let reply = decoded.response {
                        let assistantMsg = ChatMessage(role: "assistant", content: reply)
                        self.chatHistory.append(assistantMsg)
                    }

                } catch {
                    self.errorMessage = "Failed to decode JSON"
                }
            }
        }.resume()
    }
}
