import XCTest
import Ligature

final class PlatformTests: XCTestCase {
	func testLayoutTranslation() {
		let left = TextDirection(rawValue: TextLayoutDirection.left.rawValue)

		XCTAssertEqual(left.textStorageDirection(with: .leftToRight), .backward)
		XCTAssertEqual(left.textStorageDirection(with: .rightToLeft), .forward)

		let right = TextDirection(rawValue: TextLayoutDirection.right.rawValue)

		XCTAssertEqual(right.textStorageDirection(with: .leftToRight), .forward)
		XCTAssertEqual(right.textStorageDirection(with: .rightToLeft), .backward)
	}
}
