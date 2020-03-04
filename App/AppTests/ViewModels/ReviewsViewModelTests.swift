import XCTest
import AppServices
import RxSwift
import RxBlocking
@testable import App

class ReviewsViewModelTests: XCTestCase {
    
    var mockServices: MockActivitiesServices!

    override func setUp() {
        mockServices = MockActivitiesServices()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoadData() {
        mockServices.reviewsObj = Reviews.mocked()
        let viewModel = ReviewsViewModel(id: 99, offset: 5, limit: 1, service: mockServices)
        _ = try! viewModel.loadData().toBlocking().first()
        
        XCTAssertEqual(mockServices.calledId, 99)
        XCTAssertEqual(mockServices.calledOffset?.offset, 5)
        XCTAssertEqual(mockServices.calledLimit?.limit, 1)
        XCTAssertEqual(viewModel.numberOfItems(), mockServices.reviewsObj?.reviews.count)
    }
    
    func testLoadDataWithError() {
        let viewModel = ReviewsViewModel(id: 99, offset: 5, limit: 1, service: mockServices)
        XCTAssertThrowsError(try viewModel.loadData().toBlocking().first())
        XCTAssertEqual(viewModel.numberOfItems(), 0)
    }
    
    func testLoadNextPage() {
        mockServices.reviewsObj = Reviews.mocked()
        let viewModel = ReviewsViewModel(id: 99, offset: 5, limit: 1, service: mockServices)
        _ = try! viewModel.loadNextPage().toBlocking().first()
        
        XCTAssertEqual(mockServices.calledId, 99)
        XCTAssertEqual(mockServices.calledOffset?.offset, 6)
        XCTAssertEqual(mockServices.calledLimit?.limit, 1)
    }
}
