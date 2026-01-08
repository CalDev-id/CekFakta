import SwiftUI

struct ChatView: View {
    @EnvironmentObject var auth: AuthManager
    @StateObject private var viewModel = ChatViewModel()
    @State private var userInput: String = ""

    var body: some View {
        VStack(spacing: 0) {
            headerView
            chatScrollView
        }
        .safeAreaInset(edge: .bottom) {
            inputBar
                .background(Color.white)
        }
        .onAppear {
            if let email = auth.userEmail {
                viewModel.setUserKey(email)
            }
        }
        .onChange(of: auth.userEmail) { newEmail in
            if let newEmail {
                viewModel.setUserKey(newEmail)
            } else {
                // kalau logout dan email jadi nil, kosongkan UI (opsional)
                viewModel.chatHistory = []
            }
        }
    }
    private var headerView: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.title2)
                .padding(.leading, 24)
                .foregroundColor(.white)

            Spacer()
            Text("Cek Fakta Bot")
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Spacer()

            Image(systemName: "waveform")
                .font(.title2)
                .padding(.trailing, 24)
                .foregroundColor(.white)
        }
        .padding(.vertical, 10)
        .background(Color.redPrimary)
    }

    private var chatScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.chatHistory) { message in
                        ChatBubble(message: message)
                            .id(message.id)
                    }

                    if viewModel.isLoading {
                        DotLoadingView()
                            .padding(.leading, 14)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.top, 10)
                .onChange(of: viewModel.chatHistory.count) { _ in
                    scrollToBottom(proxy)
                }
                .onAppear {
                    scrollToBottom(proxy)
                }
            }
        }
    }

    private var inputBar: some View {
        HStack {
            Image(systemName: "phone.fill")
                .font(.title)
                .foregroundColor(.redPrimary)
                .padding(.trailing, 8)

            ZStack {
                if userInput.isEmpty {
                    Text("Message CekFakta")
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.leading, 18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                TextField("", text: $userInput)
                    .padding(10)
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
                    .foregroundColor(.black)
            }

            Button {
                if userInput.trimmingCharacters(in: .whitespaces).isEmpty { return }
                viewModel.addUserMessage(userInput)
                viewModel.sendMessage()
                userInput = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .font(.title)
                    .foregroundColor(.redPrimary)
            }
            .padding(.leading, 6)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .padding(.bottom, 10)
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        if let lastId = viewModel.chatHistory.last?.id {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation {
                    proxy.scrollTo(lastId, anchor: .bottom)
                }
            }
        }
    }
}
