import SwiftUI

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if message.role == "assistant" {
                // Avatar bot
                Image("logo")
                    .resizable()
                    .frame(width: 38, height: 38)
                    .cornerRadius(10)

                // Bubble bot
                Text(message.content)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
                Spacer()
            } else {
                Spacer()

                // Bubble user
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                Image(systemName: "person.circle.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
            }
        }
    }
}
