import Foundation

protocol RouterManagerConvertible {
    func asRouter() -> RouterManager
}

protocol QueryConvertible {
    func queryItems() -> [URLQueryItem]
}
