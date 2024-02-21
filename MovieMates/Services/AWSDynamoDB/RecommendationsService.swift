//
//  RecommendationsService.swift
//  MovieMates
//
//  Created by Matt Hoppitt on 19/2/2024.
//

import AWSDynamoDB

public class RecommendationsTable {
    let tableName = "MovieMates-Recommendations"
    
    public init() {
        // Configure your AWS credentials and region
        let configuration = AWSServiceConfiguration(region: .APSoutheast2, credentialsProvider: AWSStaticCredentialsProvider(accessKey: ACCESS_KEY, secretKey: SECRET_KEY))
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func generateID() -> String {
        return UUID().uuidString
    }
    
    // FOR RECOMMENDER ID
    // UIDevice.current.identifierForVendor?.uuidString
//    func addRecommendation(recommendation: Recommendation) async throws {
//        let dynamoDB = AWSDynamoDB.default()
//        guard let id = AWSDynamoDBAttributeValue() else {
//            return print("Error setting id")
//        }
//        id.s = event.id
//        
//        guard let input = AWSDynamoDBPutItemInput() else {
//            return print("Error setting tableName")
//        }
//        input.tableName = self.tableName
//
//        guard let title = AWSDynamoDBAttributeValue() else {
//            return print("Error setting title")
//        }
//        title.s = event.title
//        
//        guard let hasEndDate = AWSDynamoDBAttributeValue() else {
//            return print("Error setting isKeyDate")
//        }
//        hasEndDate.s = String(event.hasEndDate)
//        
//        guard let startDate = AWSDynamoDBAttributeValue() else {
//            return print("Error setting start date")
//        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss Z"
//        dateFormatter.timeZone = TimeZone(abbreviation: TimeZone.current.identifier)
//        let startDateString = dateFormatter.string(from: event.startDate)
//        startDate.s = startDateString
//        
//        guard let endDate = AWSDynamoDBAttributeValue() else {
//            return print("Error setting end date")
//        }
//        let endDateString = dateFormatter.string(from: event.endDate)
//        endDate.s = endDateString
//        
//        guard let who = AWSDynamoDBAttributeValue() else {
//            return print("Error setting person")
//        }
//        who.s = event.who
//        
//        guard let isKeyDate = AWSDynamoDBAttributeValue() else {
//            return print("Error setting isKeyDate")
//        }
//        isKeyDate.s = String(event.isKeyDate)
//        
//        guard let isOutForDinner = AWSDynamoDBAttributeValue() else {
//            return print("Error setting isOutForDinner")
//        }
//        isOutForDinner.s = String(event.isOutForDinner)
//        
//        input.item = [
//            "id": id,
//            "title": title,
//            "hasEndDate": hasEndDate,
//            "startDate": startDate,
//            "endDate": endDate,
//            "who": who,
//            "isKeyDate": isKeyDate,
//            "isOutForDinner": isOutForDinner,
//        ]
//
//        try await dynamoDB.putItem(input)
//        sendEventNotification(event: event, eventAction: "added")
//    }
    
    func getRecommendations() async throws -> [Recommendation] {
        let dynamoDB = AWSDynamoDB.default()
        
        guard let query = AWSDynamoDBScanInput() else {
            return []
        }
        query.tableName = tableName
        
        let response = try await dynamoDB.scan(query)
        
        var recommendationList: [Recommendation] = []
        
        for record in response.items.unsafelyUnwrapped {
            let id: String = record["id"]!.s.unsafelyUnwrapped
            let title: String = record["title"]!.s.unsafelyUnwrapped
            let type: String = record["type"]!.s.unsafelyUnwrapped
            let justification: String = record["justification"]!.s.unsafelyUnwrapped
            let recommender: String = record["recommender"]!.s.unsafelyUnwrapped
            let hasDecided: String = record["hasDecided"]!.s.unsafelyUnwrapped
            
            let recommendation = Recommendation(id: id, title: title, type: type, justification: justification, recommender: recommender, hasDecided: Bool(hasDecided) ?? false)
            recommendationList.append(recommendation)
        }
        return recommendationList
    }
    
    func deleteEvent(recommendation: Recommendation) async throws {
        let dynamoDB = AWSDynamoDB.default()
        guard let id = AWSDynamoDBAttributeValue() else {
            return print("Error setting id")
        }
        id.s = recommendation.id
        
        guard let deleteInput = AWSDynamoDBDeleteItemInput() else {
            return print("Error setting tableName")
        }
        deleteInput.tableName = self.tableName
        deleteInput.key = ["id": id]

        try await dynamoDB.deleteItem(deleteInput)
    }
}

