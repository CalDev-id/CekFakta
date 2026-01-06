//
//  ProfileView.swift
//  CekFakta
//
//  Created by Heical Chandra on 11/12/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var auth: AuthManager
    @EnvironmentObject private var vm: ProfileManager
    @State private var showEditProfile = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 24) {
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
                    VStack(spacing: 8) {
                        Text(auth.userName ?? "No Name")
                            .font(.title3)
                            .bold()

                        Text(auth.userEmail ?? "-")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Divider()
                        .padding(.horizontal)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("My Posts")
                            .font(.headline)
                            .multilineTextAlignment(.leading)

                        // ✅ ERROR MESSAGE DI SINI
                        if let err = vm.errorMessage {
                            Text(err)
                                .foregroundColor(.red)
                                .font(.caption)
                        }

                        if vm.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else if vm.news.isEmpty {
                            Text("No posts yet")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        } else {
                            ForEach(vm.news) { item in
                                if let id = item.id {
                                    NavigationLink(destination: DetailNews(newsId: id)) {
                                        NewsRow(news: item)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    Divider()
                    Button(role: .destructive) {
                        auth.logout()
                        vm.resetCache()
                    } label: {
                        Text("Logout")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()
                }
                .padding()
            }
            .refreshable {
                vm.refreshMyNews(force: true)
            }
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
        .sheet(isPresented: $showEditProfile) {
            EditProfileView()
                .environmentObject(auth)
                .environmentObject(vm)
        }


    }
}
