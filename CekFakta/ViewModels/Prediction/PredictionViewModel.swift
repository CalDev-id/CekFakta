//
//  PredictionViewModel.swift
//  CekFakta
//
//  Created by Heical Chandra on 24/11/25.
//
import Foundation

@MainActor
final class PredictionStore: ObservableObject {
    @Published var latestPrediction: News?
}

@MainActor
final class PredictionViewModel: ObservableObject {
    @Published var urlInput: String = ""
    @Published var isLoading: Bool = false
    @Published var result: News?
    @Published var errorMessage: String = ""

    private let endpoint = "http://192.168.50.110:8000/predict_test/"

    func predict() {
        Task { await predictAsync() }
    }

    private func predictAsync() async {
        guard let url = URL(string: endpoint) else {
            errorMessage = "Invalid API URL"
            return
        }

        isLoading = true
        errorMessage = ""
        result = nil
        defer { isLoading = false }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["url": urlInput]

        do {
            request.httpBody = try JSONEncoder().encode(body)
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                errorMessage = "Server error"
                return
            }

            result = try JSONDecoder().decode(News.self, from: data)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
