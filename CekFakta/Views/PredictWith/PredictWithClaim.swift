import SwiftUI

struct PredictWithClaim: View {
    @State private var claim: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
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
                Text("Claim Prediction")
                    .font(.largeTitle.bold())
                    .padding(.top, 10)
                
                Text("Enter a specific claim to analyze its validity.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // CLAIM FIELD
                VStack(alignment: .leading, spacing: 8) {
                    Text("Claim")
                        .font(.headline)
                    
                    TextEditor(text: $claim)
                        .frame(height: 140)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                }
                
                // BUTTON
                Button(action: {
                    print("Predict Claim Triggered")
                }) {
                    HStack {
                        Spacer()
                        Text("Predict")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(
                        LinearGradient(colors: [Color.redPrimary, Color.redPrimary.opacity(0.7)],
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                    .cornerRadius(18)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PredictWithClaim()
}
