//
//  PredictionViewModel.swift
//  CekFakta
//
//  Created by Heical Chandra on 24/11/25.
//

import Foundation

class PredictionViewModel: ObservableObject {
    @Published var urlInput: String = ""
    @Published var isLoading: Bool = false
    @Published var result: PredictionResponse?
    @Published var errorMessage: String = ""

    private let endpoint = "http://192.168.50.110:8000/predict_test/"

    func predict() {
        guard let url = URL(string: endpoint) else {
            self.errorMessage = "Invalid API URL"
            return
        }

        self.isLoading = true
        self.errorMessage = ""
        self.result = nil

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Body JSON → {"url": "https://..."}
        let body = ["url": urlInput]

        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            self.errorMessage = "Failed to encode request body"
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
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(PredictionResponse.self, from: data)
                    self.result = decoded
                } catch {
                    self.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

