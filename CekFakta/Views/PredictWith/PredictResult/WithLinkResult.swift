import SwiftUI

struct WithLinkResult: View {

    let prediction: PredictionResponse
    @Environment(\.dismiss) var dismiss
    @State private var expandEvidence: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                            .padding(8)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                // IMAGE + LABEL
                if let img = prediction.evidence_scraped?.first?.featured_image,
                   let url = URL(string: img) {

                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 220)
                        .frame(width: UIScreen.main.bounds.width)
                        .clipped()
                        
                        Text(prediction.classification?.final_label.capitalized ?? "-")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                            .background(
                                (prediction.classification?.final_label == "valid")
                                ? Color.blue
                                : Color.red
                            )
                            .cornerRadius(5)
                    }
                    .padding(.bottom, 20)
                }

                VStack(alignment: .leading) {

                    // TITLE
                    Text(prediction.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.vertical, 0)

                    Divider()

                    // CONTENT
                    ExpandableText(
                        text: prediction.content,
                        lineLimit: 15
                    )
                    .padding(.bottom, 10)

                    Divider()

                    // Evidence
                    if let evidences = prediction.evidence_scraped, !evidences.isEmpty {

                        SectionCard(title: "Bukti Tambahan (Evidence)") {

                            let firstEvidence = evidences[0]
                            let fullContent = firstEvidence.content ?? "Tidak ada konten"
                            let preview = String(fullContent.prefix(200))

                            VStack(alignment: .leading, spacing: 12) {

                                // IMAGE
                                if let imageUrl = firstEvidence.featured_image,
                                   let url = URL(string: imageUrl) {

                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(width: 330, height: 180)
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(12)

                                        case .success(let image):
                                            image.resizable()
                                                .scaledToFill()
                                                .frame(width: 330, height: 180)
                                                .clipped()
                                                .cornerRadius(12)

                                        case .failure(_):
                                            Color.gray.opacity(0.2)
                                                .frame(width: 330, height: 180)
                                                .overlay(Text("Gagal memuat gambar"))
                                                .cornerRadius(12)

                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .center)
                                }

                                if let judul = firstEvidence.judul, !judul.isEmpty {
                                    Text(judul)
                                        .font(.subheadline)
                                        .bold()
                                }

                                // TEKS
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
                                    withAnimation { expandEvidence.toggle() }
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

                    // Supporting links
                    if let links = prediction.evidence_links {
                        SectionCard(title: "Sumber Pendukung") {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(links, id: \.self) { link in
                                    if let url = URL(string: link) {
                                        Link(destination: url) {
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
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}
