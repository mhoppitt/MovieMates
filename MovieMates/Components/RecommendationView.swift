//
//  RecommendationView.swift
//  MovieMates
//
//  Created by Matt Hoppitt on 20/2/2024.
//

import SwiftUI

struct RecommendationView: View {
    var title: String
    var overview: String
    var posterPath: String
    @Binding var refreshed: Bool
    @State var isImageLoaded: Bool = false
    
    var body: some View {
        if (isImageLoaded) {
            Text(title).font(.title).bold()
            Text(overview)
        }
        ZStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit) // or .fill
            } placeholder: { ProgressView().onDisappear { isImageLoaded = true } }
            .frame(height: 500)
            .cornerRadius(10)
        }.mask(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .clear]), startPoint: .top, endPoint: .bottom))
    }
}

#Preview {
    RecommendationView(title: "Test", overview: "Short overview", posterPath: "1E5baAaEse26fej7uHcjOgEE2t2.jpg", refreshed: .constant(true))
}
