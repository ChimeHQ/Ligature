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

#if os(macOS)
import AppKit

@MainActor
extension PlatformTests {
	func testPositionOffset() throws {
		let view = NSTextView()

		view.text = "abcdef"

		let position = try XCTUnwrap(view.position(from: view.beginningOfDocument, offset: 3))

		XCTAssertEqual(view.offset(from: view.beginningOfDocument, to: position), 3)
	}

	func testMakeTextRange() throws {
		let view = NSTextView()

		view.text = "abcdef"

		let position = try XCTUnwrap(view.position(from: view.beginningOfDocument, offset: 3))
		_ = try XCTUnwrap(view.textRange(from: view.beginningOfDocument, to: position))
	}
}

#endif
