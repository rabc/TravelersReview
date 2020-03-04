import XCTest
@testable import App

class AppCoordinatorTests: XCTestCase {

    func testStart() {
        let window = UIWindow()
        let coordinator = AppCoordinator(window: window)
        coordinator.start()
        
        XCTAssertTrue(window.rootViewController is ReviewsListViewController)
    }

}
