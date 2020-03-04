import XCTest
@testable import AppServices

class ActivitiesServicesParametersTests: XCTestCase {

    func testLimitParameter() {
        let parameter = LimitParameter(limit: 99)
        let queryItems = parameter.queryItems()
        
        XCTAssertEqual(queryItems.first?.name, "limit")
        XCTAssertEqual(queryItems.first?.value, "99")
    }
    
    func testOffsetParameter() {
        let parameter = OffsetParameter(offset: 66)
        let queryItems = parameter.queryItems()
        
        XCTAssertEqual(queryItems.first?.name, "offset")
        XCTAssertEqual(queryItems.first?.value, "66")
    }

}
