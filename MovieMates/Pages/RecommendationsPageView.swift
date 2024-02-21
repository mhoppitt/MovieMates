//
//  RecommendationsPageView.swift
//  MovieMates
//
//  Created by Matt Hoppitt on 19/2/2024.
//

import SwiftUI

@MainActor
class RecommendationsModel: ObservableObject {
    @Published var recommendations: [Recommendation]?
    var recommendationsTable = RecommendationsTable()

    init() {}

    func fetchRecommendations() async {
        do {
            recommendations = try await recommendationsTable.getRecommendations()
        } catch let error {
            print(error)
        }
    }
}

struct MovieData: Decodable {
    var results = [MovieResults]()
}

struct MovieResults: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Float?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Float?
    let voteCount: Float?
    
    enum CodingKeys: String, CodingKey {
        case adult, id, overview, popularity, title, video
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct RecommendationsPageView: View {
    @StateObject var model = RecommendationsModel()
    @State public var refreshed: Bool = false
    @State var movieData: MovieData?
    @State var movieNum: Int = 0
    @State var isRecommendationListCompleted: Bool = false
    
    func refreshView() {
        return refreshed.toggle()
    }
    
    var body: some View {
        VStack {
            HStack() {
                Text("")
                    .frame(width: 40) // element with equal width of button to centre heading
                    .padding(.leading)
                Spacer()
                Image(systemName: "movieclapper.fill")
                Text("MovieMates")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
//                    showingSheet.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(.trailing)
                }
//                .sheet(isPresented: $showingSheet, onDismiss: {
//                    refreshView()
//                }) {
//                    AddEventSheetView(type: "Add")
//                }
            }.padding(.bottom, 10)
            let recommendationData = movieData?.results[0]
            if (!isRecommendationListCompleted) {
                if ((recommendationData?.title?.isEmpty) != nil) {
                    RecommendationView(title: recommendationData?.title ?? "", overview: recommendationData?.overview ?? "", posterPath: recommendationData?.posterPath ?? "", refreshed: $refreshed)
                }
                HStack(spacing: 50) {
                    Button(action: {
                        if (((model.recommendations?.count ?? 0) - 2) >= movieNum) {
                            movieNum += 1
                        } else {
                            isRecommendationListCompleted = true
                        }
                        refreshView()
                    }) {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                    Button(action: {
                        if (((model.recommendations?.count ?? 0) - 2) >= movieNum) {
                            movieNum += 1
                        } else {
                            isRecommendationListCompleted = true
                        }
                        refreshView()
                    }) {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                }
            } else {
                Spacer()
                Text("No more recommendations :(")
            }
//                .sheet(isPresented: $showingSheet, onDismiss: {
//                    refreshView()
//                }) {
//                    AddEventSheetView(type: "Add")
//                }
            Spacer()
        }
        .refreshable {
            refreshView()
        }
        .task(id: refreshed) {
            await model.fetchRecommendations()
            self.getMovieData(title: model.recommendations?[movieNum].title ?? "")
        }
        .padding()
    }
    
    func getMovieData(title: String) {
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(title)&include_adult=false&language=en-US") else {
            fatalError("Invalid URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(TMDB_KEY)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{ return }
            do {
                let decodedData =  try JSONDecoder().decode(MovieData.self, from: data)
                DispatchQueue.main.async {
                    self.movieData = decodedData
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}

#Preview {
    RecommendationsPageView()
}
