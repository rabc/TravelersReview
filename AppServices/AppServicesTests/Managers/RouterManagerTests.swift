import XCTest
@testable import AppServices

class RouterManagerTests: XCTestCase {
    
    func testInit() {
        let manager = RouterManager(endpoint: "/endpoint", method: .get)
        XCTAssertEqual(manager.endpoint, "/endpoint")
        XCTAssertEqual(manager.method, .get)
    }
    
    func testAsURL() {
        let manager = RouterManager(endpoint: "/endpoint", method: .get)
        let url = manager.asURL()
        
        XCTAssertEqual(url.absoluteString, "https://travelers-api.getyourguide.com/endpoint")
    }
    
}
