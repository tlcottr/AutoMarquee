import XCTest
@testable import AutoMarquee

final class AutoMarqueeModelTests: XCTestCase {
    func testOffsetCalculation() {
        var model = MarqueeModel(targetVelocity: 30, spacing: 10, direction: .rightToLeft)
        model.contentWidth = 200
        model.tick(at: Date())
        XCTAssert(model.offset < 0) // Test some condition
    }
}
