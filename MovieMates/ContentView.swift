//
//  ContentView.swift
//  MovieMates
//
//  Created by Matt Hoppitt on 19/2/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Group {
                RecommendationsPageView()
                    .tabItem {
                        Label("Recommendations", systemImage: "house.fill")
                    }
                MoviesPageView()
                    .tabItem {
                        Label("Movies", systemImage: "popcorn.fill")
                    }
                TvShowsPageView()
                    .tabItem {
                        Label("TV Shows", systemImage: "tv.fill")
                    }
            }
        }
    }
}

#Preview {
    ContentView()
//        .environment(\.colorScheme, .dark)
}
