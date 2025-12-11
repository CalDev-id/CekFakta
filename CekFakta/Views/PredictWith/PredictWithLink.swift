//
//  PredictWithLink.swift
//  CekFakta
//
//  Created by Heical Chandra on 10/12/25.
//


import SwiftUI

struct PredictWithLink: View {
    @StateObject private var vm = PredictionViewModel()
    @State private var expandEvidence: Bool = false

    var body: some View {

        // === ZSTACK PENTING AGAR LOADING FULLSCREEN ===
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {

                    Text("Cek Fakta Berita")
                        .font(.largeTitle).bold()

                    Text("Masukkan URL berita untuk dianalisis")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    // Input Field
                    TextField("https://contoh.com/berita", text: $vm.urlInput)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)

                    // Predict Button
                    Button(action: {
                        hideKeyboard()        // <<< auto close keyboard
                        vm.predict()
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Analisis").bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vm.urlInput.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .disabled(vm.urlInput.isEmpty)

                    // Error UI
                    if !vm.errorMessage.isEmpty {
                        Text("⚠️ \(vm.errorMessage)")
                            .foregroundColor(.red)
                            .padding(.top)
                    }

                    // RESULT VIEW
                    if let result = vm.result {

                        VStack(alignment: .leading, spacing: 18) {

                            // 1. URL
                            SectionCard(title: "URL") {
                                Text(result.url)
                                    .font(.callout)
                                    .foregroundColor(.blue)
                                    .lineLimit(2)
                            }


                            // 2. TITLE
                            SectionCard(title: "Judul Berita") {
                                Text(result.title)
                                    .font(.headline)
                            }


                            // 3. KLASIFIKASI
                            if let classif = result.classification {
                                SectionCard(title: "Klasifikasi") {

                                    LabelCapsule(
                                        text: classif.final_label.uppercased(),
                                        color: classif.final_label.lowercased() == "hoaks" ? .red : .green
                                    )

                                    Text("Confidence: **\(String(format: "%.2f", classif.final_confidence))%**")
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                }
                            }

                            // 4. PENJELASAN
                            if let explanation = result.explanation {
                                SectionCard(title: "Penjelasan Singkat") {
                                    Text(explanation)
                                        .font(.body)
                                }
                            }

                            // 5. EVIDENCE
                            if let evidences = result.evidence_scraped, !evidences.isEmpty {
                                SectionCard(title: "Bukti Tambahan (Evidence)") {

                                    let firstEvidence = evidences[0]
                                    let content = firstEvidence.content
                                    let fullContent = content.content ?? "Tidak ada konten"
                                    let preview = String(fullContent.prefix(200))

                                    VStack(alignment: .leading, spacing: 12) {

                                        if let imageUrl = content.featured_image,
                                           let url = URL(string: imageUrl) {

                                            AsyncImage(url: url) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 180)
                                                        .clipped()
                                                        .cornerRadius(12)
                                                case .failure(_):
                                                    Color.gray.opacity(0.2)
                                                        .frame(height: 180)
                                                        .overlay(Text("Gagal memuat gambar"))
                                                @unknown default:
                                                    EmptyView()
                                                }
                                            }
                                        }

                                        if let judul = content.judul, !judul.isEmpty {
                                            Text(judul)
                                                .font(.subheadline)
                                                .bold()
                                        }

                                        HStack(spacing: 10) {
                                            if let sumber = content.sumber {
                                                Text(sumber)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            if let tanggal = content.tanggal {
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
                                        .padding(.top, 6)
                                    }
                                }
                            }
                            // 6. SUMBER PENDUKUNG
                            if let links = result.evidence_links {
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
                        .padding(.top, 10)
                    }

                    Spacer()
                }
                .padding()
            }

            // === FULLSCREEN LOADING ===
            if vm.isLoading {
                ZStack {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(2)
                        Text("Sedang menganalisis...")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(40)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
                .transition(.opacity)
            }
        }
    }
}


// MARK: - Auto Close Keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}


struct SectionCard<Content: View>: View {
    let title: String
    let content: () -> Content

    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2, y: 1)
    }
}

struct LabelCapsule: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .bold()
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}
