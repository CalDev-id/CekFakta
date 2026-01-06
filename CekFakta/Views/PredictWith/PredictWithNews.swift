//
//  PredictWithNews.swift
//  CekFakta
//
//  Created by Heical Chandra on 10/12/25.
//

import SwiftUI

struct PredictWithNews: View {
    @State private var title: String = ""
    @State private var content: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .padding(8)
                }
                Spacer()
            }
            .padding(.horizontal, 10)
            VStack(alignment: .leading, spacing: 20) {
                
                Text("News Prediction")
                    .font(.largeTitle.bold())
                    .padding(.top, 10)
                
                Text("Paste your news article title and content below to analyze.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // TITLE FIELD
                VStack(alignment: .leading, spacing: 8) {
                    Text("News Title")
                        .font(.headline)
                    
                    TextField("Enter news title...", text: $title)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                }
                
                // CONTENT FIELD
                VStack(alignment: .leading, spacing: 8) {
                    Text("News Content")
                        .font(.headline)
                    
                    TextEditor(text: $content)
                        .frame(height: 180)
                        .padding(10)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                }
                
                // BUTTON
                Button(action: {
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
    PredictWithNews()
}
