import Foundation

enum ActivitiesServicesRouter: RouterManagerConvertible {
    case reviews(id: Int)
    
    func asRouter() -> RouterManager {
        var endpoint = "/activities"
        
        switch self {
        case .reviews(let id):
            endpoint.append("/\(id)/reviews")
        }
        
        return RouterManager(endpoint: endpoint, method: .get)
    }
}
