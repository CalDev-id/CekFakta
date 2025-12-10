import SwiftUI

struct DetailNews: View {
    let newsId: String
    @StateObject private var vm = DetailNewsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            if vm.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let error = vm.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .padding()
            } else if let news = vm.news {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                                .padding(8)
                        }

                        
                        Spacer()
                        
                        Button(action: {
                            print("Menu tapped")
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                                .padding(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    if let img = news.evidence_scraped?.first?.content?.featured_image,
                       let url = URL(string: img) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 220)
                        .frame(width: UIScreen.main.bounds.width)
                        .clipped()
                    }
                    VStack{
                        Text(news.title ?? "-")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Text(news.classification ?? "-")
                                .font(.subheadline)
                                .foregroundColor(news.classification == "valid" ? .blue : .red)
                            
                            if let date = news.inserted_at {
                                Text("• \(formatISODate(date))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Divider()
                        
                        Text((news.content ?? "-").replacingOccurrences(of: "\\n", with: "\n"))
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        Divider()
                        
                        if let evidenceList = news.evidence_scraped {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Evidence Sources")
                                    .font(.headline)
                                
                                ForEach(evidenceList, id: \.url) { ev in
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(ev.content?.judul ?? "-")
                                            .font(.subheadline)
                                            .bold()
                                        
                                        if let sumber = ev.content?.sumber {
                                            Text("Sumber: \(sumber)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        if let link = ev.content?.link,
                                           let url = URL(string: link) {
                                            Link("Buka Link", destination: url)
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .padding(.vertical, 6)
                                    
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding()
                    
                }
                .padding()
                
            }
        }
        .task {
            await vm.fetchDetail(newsId: newsId)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        
        
    }}
