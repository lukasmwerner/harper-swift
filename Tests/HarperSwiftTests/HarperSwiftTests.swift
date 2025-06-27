import XCTest
@testable import HarperSwift

final class HarperSwiftTests: XCTestCase {
    func testHello() {
        XCTAssertEqual(Harper.hello(), "Hello, World!")
    }
}