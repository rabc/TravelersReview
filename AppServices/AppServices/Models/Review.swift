import Foundation

public struct Reviews: Decodable {
    public let reviews: [Review]
    public let totalCount: Int
    public let averageRating: Double
}

public struct Review: Decodable {
    public enum TravelerType: String, Decodable {
        case solo
        case couple
        case friends
        case youngFamily = "young family"
        case oldFamily = "old family"
    }
    
    public struct Author: Decodable {
        public let fullName: String
        public let country: String?
    }
    
    public let id: Int
    public let author: Author
    public let title: String
    public let message: String
    public let enjoyment: String
    public let isAnonymous: Bool
    public let rating: Int
    public let created: Date
    public let language: String
    public let travelerType: TravelerType?
}

extension Review: Equatable {
    public static func == (lhs: Review, rhs: Review) -> Bool {
        return lhs.id == rhs.id
    }
}
