import Foundation
import AppServices
import RxSwift

class MockActivitiesServices: ActivitiesServicesProtocol {
    
    enum MockActivitiesServices: Error {
        case genericError
    }
    
    var reviewsObj: Reviews?
    var calledId: Int?
    var calledLimit: LimitParameter?
    var calledOffset: OffsetParameter?
    func reviews(id: Int, limit: LimitParameter?, offset: OffsetParameter?) -> Single<Reviews> {
        calledId = id
        calledLimit = limit
        calledOffset = offset
        if let reviewsObj = reviewsObj {
            return Single.just(reviewsObj)
        } else {
            return Single.error(MockActivitiesServices.genericError)
        }
    }
}

extension Reviews {
    static func mocked() -> Reviews {
        let jsonURL = Bundle(for: MockActivitiesServices.self).url(forResource: "reviews", withExtension: "json")!
        let data = try! Data(contentsOf: jsonURL)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let mockedData = try! decoder.decode(Reviews.self, from: data)
        
        return mockedData
    }
}
