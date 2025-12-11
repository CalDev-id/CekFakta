//
//  HomeScreen.swift
//  CekFakta
//
//  Created by Heical Chandra on 24/11/25.
//
import SwiftUI

struct HomeScreen: View {
    @StateObject private var vm = NewsViewModel()
    let tab = ["All News", "Valid", "Hoaks"]
        @State var selectedIndex = 0
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
                if vm.isLoading {
                    ProgressView("Loading...")
                } else if let error = vm.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                        VStack {
                            HStack{
                                Image("logo")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Spacer()
                                Image("cal")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            }
                            .padding(.horizontal, 20)
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Daily News")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)

                                Text("Feed")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .font(.system(size: 35))
                            .padding(.top, 20)
                            HStack {
                                ForEach(tab.indices, id: \.self) { index in
                                    Button(action: {
                                        selectedIndex = index
                                    }) {
                                        Text(tab[index])
                                            .foregroundColor(index == selectedIndex ? Color.redPrimary : Color.gray)
                                            .padding(.vertical)
                                            .overlay(
                                                Rectangle()
                                                    .fill(index == selectedIndex ? Color.redPrimary : Color.clear)
                                                            .frame(height: 2)
                                                            .padding(.top, 0),
                                                        alignment: .bottom
                                                    )
                                            .padding(.trailing)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, -10)
                            Divider()
                                .padding(.top, -9)
                            if let top = filteredNews.first {
                                NavigationLink(destination: DetailNews(newsId: top.id)) {
                                    TopNewsCard(news: top)
                                }
                                .buttonStyle(.plain)
                            }
                            Divider()
                                .offset(y: 70)
                                .padding(.horizontal)
                            ForEach(Array(filteredNews.dropFirst().reversed())) { item in
                                NavigationLink(destination: DetailNews(newsId: item.id)) {
                                    NewsRow(news: item)
                                        .padding(.horizontal, 20)
                                }
                                .buttonStyle(.plain)
                            }

                        }
                        .padding(.bottom, 100)
                }
                }
        .background(Color(.systemBackground))
        .task { await vm.fetchNews() }
        
    }
}
extension HomeScreen {
    var filteredNews: [News] {
        switch selectedIndex {
        case 1:
            // Valid news
            return vm.newsList.filter { $0.classification?.lowercased() == "valid" }
        case 2:
            // Hoaks news
            return vm.newsList.filter { $0.classification?.lowercased() == "hoaks" }
        default:
            // All news
            return vm.newsList
        }
    }
}

#Preview { HomeScreen() }
