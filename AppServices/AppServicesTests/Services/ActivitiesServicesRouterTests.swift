import XCTest
@testable import AppServices

class ActivitiesServicesRouterTests: XCTestCase {

    func testServiceRouter() {
        let endpoint = ActivitiesServicesRouter.reviews(id: 99)
        let router = endpoint.asRouter()
        
        XCTAssertEqual(router.endpoint, "/activities/99/reviews")
        XCTAssertTrue(router.method == .get)
    }

}
