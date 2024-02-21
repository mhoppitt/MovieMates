//
//  Recommendation.swift
//  MovieMates
//
//  Created by Matt Hoppitt on 19/2/2024.
//

public struct Recommendation: Codable, Identifiable {
    public var id: String
    var title: String
    var type: String
    var justification: String
    var recommender: String
    var hasDecided: Bool
    
    init(id: String, title: String, type: String, justification: String, recommender: String, hasDecided: Bool) {
        self.id = id
        self.title = title
        self.type = type
        self.justification = justification
        self.recommender = recommender
        self.hasDecided = hasDecided
    }
}

