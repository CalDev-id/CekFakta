import SwiftUI

struct PredictWithLink: View {
    @StateObject private var vm = PredictionViewModel()
    @State private var expandEvidence: Bool = false
    @Environment(\.dismiss) var dismiss
    // Navigation state
    @State private var goToResult: Bool = false
    @State private var resultNewsId: String = ""

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                                .padding(8)
                        }
                        Spacer()
                    }

                    Text("Cek Fakta Berita")
                        .font(.largeTitle).bold()

                    Text("Masukkan URL berita untuk dianalisis")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    TextField("https://contoh.com/berita", text: $vm.urlInput)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)

                    Button(action: {
                        hideKeyboard()
                        vm.predict()
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Analisis").bold()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(vm.urlInput.isEmpty ? Color.gray : Color.redPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                    .disabled(vm.urlInput.isEmpty)

                    if !vm.errorMessage.isEmpty {
                        Text("⚠️ \(vm.errorMessage)")
                            .foregroundColor(.red)
                            .padding(.top)
                    }

                    Spacer()
                }
                .padding()
            }

            if vm.isLoading {
                LoadingView()
            }
        }
        .navigationBarBackButtonHidden(true)
        // Use onReceive on the Published publisher (no Equatable required)
        .onReceive(vm.$result) { newValue in
            guard newValue != nil else { return }
            self.goToResult = true
        }

        // Navigate when goToResult becomes true (root NavigationStack already in ContentView)
        .navigationDestination(isPresented: $goToResult) {
            if let res = vm.result {
                WithLinkResult(prediction: res)
            } else {
                Text("Terjadi kesalahan: hasil analisis kosong.")
                    .foregroundColor(.red)
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

#Preview {
    PredictWithLink()
}
