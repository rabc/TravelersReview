import XCTest
import RxSwift
import RxBlocking
@testable import AppServices

class RequestManagerTests: XCTestCase {

    func testMakeGetRequestSuccess() {
        let session = MockURLSession()

        let fakeRouter = FakeRouter.testGet.asRouter()

        let response = FakeResponse(name: "My Name")
        session.data = try! JSONEncoder().encode(response)
        session.response = HTTPURLResponse(url: fakeRouter.asURL(),
                                           statusCode: 200,
                                           httpVersion: nil, headerFields: nil)

        let manager = RequestManager(session: session)

        let request: BlockingObservable<FakeResponse> = manager.make(route: FakeRouter.testGet, parameters: [FakeParameters()]).toBlocking()
        let result = try! request.first()


        XCTAssertEqual(result!, response)
        XCTAssertNil(session.request!.httpBody)
        XCTAssertEqual(session.request?.url?.absoluteString, "\(fakeRouter.asURL().absoluteString)?key=value")
        XCTAssertEqual(session.request?.httpMethod, fakeRouter.method.rawValue)
        XCTAssertEqual(session.request?.allHTTPHeaderFields?["Content-Type"], fakeRouter.contentType.rawValue)
    }

    func testMakeRequestServerError() {
        let session = MockURLSession()

        let fakeRouter = FakeRouter.testGet.asRouter()

        session.error = FakeError.testError
        session.response = HTTPURLResponse(url: fakeRouter.asURL(),
                                           statusCode: 500,
                                           httpVersion: nil, headerFields: nil)

        let manager = RequestManager(session: session)

        let request: BlockingObservable<FakeResponse> = manager.make(route: FakeRouter.testGet).toBlocking()

        XCTAssertThrowsError(try request.first(), "Should throw error") { (error) in
            if case let RequestError.serverError(status, error) = error {
                XCTAssertEqual(status, session.response!.statusCode)
                XCTAssertEqual(error as? FakeError, FakeError.testError)
            } else {
                XCTFail("Wrong error was thrown")
            }
        }
    }
}
