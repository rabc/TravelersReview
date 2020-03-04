import XCTest
import RxSwift
import RxBlocking
@testable import AppServices

class MockRequestManager: RequestManager {
    
    enum MockRequestManagerError: Error {
        case genericError
    }
    
    var response: Decodable?
    
    var route: RouterManagerConvertible?
    var parameters: [QueryConvertible]?
    override func make<T: Decodable>(route: RouterManagerConvertible, parameters: [QueryConvertible] = []) -> Single<T> {
        self.route = route
        self.parameters = parameters
        
        if let response = response {
            return Single.just(response as! T)
        }
        
        return Single.error(MockRequestManagerError.genericError)
    }
}

class ActivitiesServicesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReviews() {
        let reviews = mockReviews()
        
        let manager = MockRequestManager()
        manager.response = reviews
        
        let limit = LimitParameter(limit: 5)
        let offset = OffsetParameter(offset: 10)
        
        let services = ActivitiesServices(request: manager)
        if let result = try! services.reviews(id: 99, limit: limit, offset: offset).toBlocking().first() {
            XCTAssertEqual(result.reviews[0], reviews.reviews[0])
            XCTAssertEqual(result.reviews[1], reviews.reviews[1])
        } else {
            XCTFail("Faied to fetch reviews")
        }
    }
}

extension ActivitiesServicesTests {
    func mockReviews() -> Reviews {
        
        let firstReview = Review(id: 1, author: Review.Author(fullName: "First Name", country: "Germany"),
                                 title: "First Title", message: "First Message",
                                 enjoyment: "", isAnonymous: false,
                                 rating: 10, created: Date(),
                                 language: "de", travelerType: .solo)
        
        let secondReview = Review(id: 1, author: Review.Author(fullName: "Second Name", country: "Spain"),
                                 title: "Second Title", message: "Second Message",
                                 enjoyment: "", isAnonymous: false,
                                 rating: 10, created: Date(),
                                 language: "es", travelerType: .youngFamily)
        
        return Reviews(reviews: [firstReview, secondReview], totalCount: 2, averageRating: 10)
    }
}
