//
//  LoadingView.swift
//  CekFakta
//
//  Created by Heical Chandra on 11/12/25.
//

import SwiftUI

struct InfoCard: Identifiable {
    let id = UUID()
    let title: String
    let content: String
}

struct LoadingView: View {
    let cards: [InfoCard] = [
        InfoCard(
            title: "The More You Know",
            content: "Many fake news use altered or photoshopped images"
        ),
        InfoCard(
            title: "Be Critical",
            content: "Always verify information using multiple trusted sources"
        )
    ]

    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Image("loading")
            Text("Scanning Article...")
                .font(.headline)
            Text("Currently scanning and reviewing this article.\nPlease wait a minute for the result.")
                .multilineTextAlignment(.center)
                .fontWeight(.light)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Spacer()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(cards) { card in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.redPrimary)
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(card.title)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.redPrimary)

                                Text(card.content)
                                    .lineLimit(2)
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(12)
                        .frame(width: 240, height: 80, alignment: .topLeading)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                        )
                    }
                }
                .padding(.leading, 20)
                .padding(.bottom, 20)
                .padding(.top, 80)
            }
            Button(action: {}, label: {
                Text("Cancel")
                    .fontWeight(.medium)
            })
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.redPrimary, lineWidth: 2)
            )
            .padding(.horizontal, 20)
        }
        .background(.white)
    }
}

#Preview {
    LoadingView()
}
