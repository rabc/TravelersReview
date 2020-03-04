import Foundation

public struct LimitParameter: QueryConvertible {
    public let limit: Int
    
    public init(limit: Int) {
        self.limit = limit
    }
    
    func queryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "limit", value: String(limit))]
    }
}

public struct OffsetParameter: QueryConvertible {
    public let offset: Int
    
    public init(offset: Int) {
        self.offset = offset
    }
    
    func queryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "offset", value: String(offset))]
    }
}
