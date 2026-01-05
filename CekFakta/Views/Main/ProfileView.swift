//
//  ProfileView.swift
//  CekFakta
//
//  Created by Heical Chandra on 11/12/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthManager
    @StateObject private var vm = ProfileNewsViewModel()
    @State private var showEditProfile = false

    var body: some View {
        ZStack(alignment: .topTrailing) {

            // =======================
            // MAIN CONTENT
            // =======================
            VStack(spacing: 24) {

                // Avatar
                if let avatar = auth.avatarURL,
                   let url = URL(string: avatar) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.secondary)
                        .frame(width: 100, height: 100)
                }

                // User info
                VStack(spacing: 8) {
                    Text(auth.userName ?? "No Name")
                        .font(.title3)
                        .bold()

                    Text(auth.userEmail ?? "-")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("My Posts")
                        .font(.headline)

                    if vm.isLoading {
                        ProgressView()
                    } else if vm.news.isEmpty {
                        Text("No posts yet")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    } else {
                        ForEach(vm.news) { item in
                            NewsRow(news: item) // 👉 pakai card yang sudah ada
                        }
                    }
                }
                Divider()

                // Logout
                Button(role: .destructive) {
                    auth.logout()
                } label: {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle("Profile")

            // =======================
            // EDIT BUTTON (MANUAL)
            // =======================
            Button {
                showEditProfile = true
            } label: {
                Text("Edit")
                    .font(.subheadline)
                    .bold()
            }
            .padding(.trailing, 16)
            .padding(.top, 8)
        }
        .onAppear {
            Task { await vm.fetchMyNews() }
        }
        .sheet(isPresented: $showEditProfile) {
            EditProfileView()
                .environmentObject(auth)
        }
    }
}
