import XCTest
import AppServices
@testable import App

class ListTableViewCellTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSetup() {
        let review = Reviews.mocked().reviews.first!
        let cell = ListTableViewCell.instantiate()
        cell.setup(with: review)
        
        XCTAssertEqual(cell.authorNameLabel.text, "\(review.author.fullName) (\(review.author.country!))")
        XCTAssertEqual(cell.dateLabel.text, DateFormatCacheManager.shared.shortDateStyle.string(from: review.created))
        XCTAssertEqual(cell.reviewTextLabel.text, review.message)
        XCTAssertEqual(cell.iconImageView.image, UIImage.iconSolo)
    }

}
