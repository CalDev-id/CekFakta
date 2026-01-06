//
//  NewsViewModel.swift
//  CekFakta
//
//  Created by Heical Chandra on 09/12/25.
//

import Foundation

@MainActor
class NewsViewModel: ObservableObject {
    @Published var newsList: [News] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    let baseURL = "http://192.168.50.110:8000"

    func fetchNews() async {
        guard let url = URL(string: "\(baseURL)/news") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([News].self, from: data)
            newsList = decoded
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

@MainActor
class DetailNewsViewModel: ObservableObject {
    @Published var news: News?
    @Published var isLoading = false
    @Published var errorMessage: String?

    let baseURL = "http://192.168.50.110:8000"

    func fetchDetail(newsId: String) async {
        guard let url = URL(string: "\(baseURL)/news/id/\(newsId)") else {
            errorMessage = "Invalid URL"
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(News.self, from: data)
            self.news = decoded
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

@MainActor
class ShareNewsViewModel: ObservableObject {

    @Published var isLoading = false
    @Published var isSuccess = false
    @Published var errorMessage: String?

    private let baseURL = "http://192.168.50.110:8000"

    // DTO LOKAL (PRIVATE)
    private struct SharePayload: Codable {
        let url: String
        let title: String
        let content: String
        let classification: Classification
        let evidence_links: [String]?
        let evidence_scraped: [EvidenceScraped]?
        let explanation: String?
    }

    func shareNews(_ news: News) async {
        guard let url = URL(string: "\(baseURL)/news") else { return }
        guard let token = Keychain.load("access_token") else {
            errorMessage = "Not authenticated"
            return
        }

        let payload = SharePayload(
            url: news.url ?? "",
            title: news.title ?? "",
            content: news.content ?? "",
            classification: news.classification ?? Classification(final_label: "-", final_confidence: 0),
            evidence_links: news.evidence_links,
            evidence_scraped: news.evidence_scraped,
            explanation: news.explanation
        )

        do {
            isLoading = true

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = try JSONEncoder().encode(payload)

            let (_, response) = try await URLSession.shared.data(for: request)

            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }

            isSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
