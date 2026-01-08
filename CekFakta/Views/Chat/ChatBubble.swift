import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if message.role == "assistant" {
                // Avatar bot
                Image("logo")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .cornerRadius(100)

                // Bubble bot
                Text(message.content)
                    .padding()
                    .background(Color.secondary)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                Spacer()
            } else {
                Spacer()

                // Bubble user
                Text(message.content)
                    .padding()
                    .background(Color.redPrimary.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                Image("cal")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .cornerRadius(100)
            }
        }
    }
}
