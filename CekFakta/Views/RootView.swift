//
//  RootView.swift
//  CekFakta
//
//  Created by Heical Chandra on 18/12/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthManager

    var body: some View {
        Group {
            if auth.isLoading {
                SplashView()
            } else if auth.isAuthenticated {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
}


struct SplashView: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}
