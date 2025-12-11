import SwiftUI

struct DetailNews: View {
    let newsId: String
    @StateObject private var vm = DetailNewsViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var expandEvidence: Bool = false
    
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
                VStack(alignment: .leading, spacing: 8) {
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
                        ZStack(alignment: .bottomLeading){
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(height: 220)
                            .frame(width: UIScreen.main.bounds.width)
                            .clipped()
                            
                            Text((news.classification ?? "-").capitalizingFirstLetter)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 15)
                                .background(news.classification == "valid" ? .blue : Color.redPrimary)
                                .cornerRadius(5)

                        }
                        .padding(.bottom, 20)
                    }
                    VStack (alignment: .leading){
                        HStack{
                            Image("info")
                                .resizable()
                                .frame(width: 45, height: 45)
                                .shadow(radius: 2)
                            Text("Reason why this news fake or not")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.black)
                        }
                        .padding()
                        .background(Color.greyDetail)
                        .cornerRadius(5)
                        .shadow(radius: 2)
                        
                        Text(news.title ?? "-")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                        HStack {
                            Image("cal")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            VStack(alignment: .leading){
                                Text("Heical Chandra")
                                if let date = news.inserted_at {
                                    Text("\(formatISODate(date))")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        
                        Divider()
                        
                        ExpandableText(
                            text: news.content ?? "-",
                            lineLimit: 15 // tampilkan hanya 3 baris pertama
                        )
                        .padding(.bottom, 10)
                        
                        Divider()
                        //evidence
                        if let evidences = news.evidence_scraped, !evidences.isEmpty {
                            SectionCard(title: "Bukti Tambahan (Evidence)") {

                                let firstEvidence = evidences[0]
                                let content = firstEvidence.content
                                let fullContent = content?.content ?? "Tidak ada konten"
                                let preview = String(fullContent.prefix(200))

                                VStack(alignment: .leading, spacing: 12) {

                                    if let imageUrl = content?.featured_image,
                                       let url = URL(string: imageUrl) {

                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .frame(width: 330, height: 180) // fixed size
                                                    .background(Color.gray.opacity(0.1))
                                                    .cornerRadius(12)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 330, height: 180) // fixed size
                                                    .clipped()
                                                    .cornerRadius(12)
                                            case .failure(_):
                                                Color.gray.opacity(0.2)
                                                    .frame(width: 330, height: 180) // fixed size
                                                    .overlay(Text("Gagal memuat gambar"))
                                                    .cornerRadius(12)
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    }

                                    if let judul = content?.judul, !judul.isEmpty {
                                        Text(judul)
                                            .font(.subheadline)
                                            .bold()
                                    }

                                    HStack(spacing: 10) {
                                        if let sumber = content?.sumber {
                                            Text(sumber)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        if let tanggal = content?.tanggal {
                                            Text(tanggal)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }

                                    if expandEvidence {
                                        Text(fullContent)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                    } else {
                                        Text(preview + (fullContent.count > 200 ? "…" : ""))
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                    }

                                    Button(action: {
                                        withAnimation {
                                            expandEvidence.toggle()
                                        }
                                    }) {
                                        Text(expandEvidence ? "Lihat lebih sedikit ▲" : "Lihat selengkapnya ▼")
                                            .font(.callout)
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.vertical, 6)
                                }
                                
                            }
                            .padding(.vertical, 10)
                        }

                        //bukti pendukung
                        if let links = news.evidence_link {
                            SectionCard(title: "Sumber Pendukung") {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(links, id: \.self) { link in
                                        Link(destination: URL(string: link)!) {
                                            HStack {
                                                Image(systemName: "link")
                                                Text(link)
                                                    .foregroundColor(.blue)
                                                    .lineLimit(1)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
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

extension String {
    var capitalizingFirstLetter: String {
        guard let first = self.first else { return self }
        return first.uppercased() + self.dropFirst()
    }
}

struct ExpandableText: View {
    let text: String
    let lineLimit: Int
    
    @State private var expanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(text.replacingOccurrences(of: "\\n", with: "\n"))
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineLimit(expanded ? nil : lineLimit) // <-- batasi jumlah baris
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            
            Button(action: {
                withAnimation {
                    expanded.toggle()
                }
            }) {
                Text(expanded ? "Lihat lebih sedikit ▲" : "Lihat selengkapnya ▼")
                    .font(.callout)
                    .foregroundColor(.blue)
            }
        }
    }
}
