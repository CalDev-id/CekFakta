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
        guard let url = URL(string: "\(baseURL)/news/\(newsId)") else {
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
