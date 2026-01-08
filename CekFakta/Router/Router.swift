//
//  Router.swift
//  CekFakta
//
//  Created by Heical Chandra on 07/01/26.
//
import SwiftUI

@MainActor
final class Router: ObservableObject {

    enum Tab: Int {
        case home = 1
        case check = 2
        case chat = 3
        case profile = 4
    }

    enum Destination: Hashable {
        case detailNews(id: String)
        case predictResult
        case predictWithLink
        case predictWithClaim
        case predictWithNews
    }

    @Published var navPath = NavigationPath()
    @Published var selectedTab: Tab = .home

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func navigateBack() {
        guard !navPath.isEmpty else { return }
        navPath.removeLast()
    }

    func navigateHome() {
        navPath.removeLast(navPath.count)
        selectedTab = .home
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }

    /// (opsional) pindah tab tanpa pop
    func switchTab(_ tab: Tab) {
        selectedTab = tab
    }
}
