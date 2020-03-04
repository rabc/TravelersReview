import Foundation
@testable import AppServices

enum FakeRouter: RouterManagerConvertible {
    case testGet
    
    func asRouter() -> RouterManager {
        return RouterManager(endpoint: "/test", method: .get)
    }
}

struct FakeResponse: Codable, Equatable {
    let name: String
    
    static func ==(lhs: FakeResponse, rhs: FakeResponse) -> Bool {
        return lhs.name == rhs.name
    }
}

struct FakeParameters: QueryConvertible {
    func queryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "key", value: "value")]
    }
}

enum FakeError: Error {
    case testError
}
