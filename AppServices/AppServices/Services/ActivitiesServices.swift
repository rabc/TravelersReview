import Foundation
import RxSwift

public protocol ActivitiesServicesProtocol {
    func reviews(id: Int, limit: LimitParameter?, offset: OffsetParameter?) -> Single<Reviews>
}

final public class ActivitiesServices: ActivitiesServicesProtocol {
    let request: RequestManager
    
    public init() {
        self.request = RequestManager.shared
    }
    
    init(request: RequestManager) {
        self.request = request
    }
    
    public func reviews(id: Int, limit: LimitParameter? = nil, offset: OffsetParameter? = nil) -> Single<Reviews> {
        var parameters = [QueryConvertible]()
        
        if let limit = limit {
            parameters.append(limit)
        }
        
        if let offset = offset {
            parameters.append(offset)
        }
        
        return request.make(route: ActivitiesServicesRouter.reviews(id: id), parameters: parameters)
    }
}

