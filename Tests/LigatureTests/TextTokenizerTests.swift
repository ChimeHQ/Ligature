import XCTest
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

typealias TextView = NSTextView

extension NSTextView {
	var text: String {
		get { string }
		set { self.string = newValue }
	}
}

#elseif canImport(UIKit)
import UIKit

typealias TextView = UITextView

#endif

import Ligature

final class TextTokenizerTests: XCTestCase {
	@MainActor
	func testTextInputTokenizerFallback() throws {
		let input = TextView()
		input.text = "abc def"

		let tokenzier = TextInputStringTokenizer(textInput: input)

		let start = input.beginningOfDocument
		let middle = try XCTUnwrap(input.position(from: start, offset: 1))
		let end = try XCTUnwrap(input.position(from: start, offset: 3))

		XCTAssertFalse(tokenzier.isPosition(start, atBoundary: .word, inDirection: .storage(.forward)))
		XCTAssertTrue(tokenzier.isPosition(start, atBoundary: .word, inDirection: .storage(.backward)))

		XCTAssertFalse(tokenzier.isPosition(middle, atBoundary: .word, inDirection: .storage(.forward)))
		XCTAssertFalse(tokenzier.isPosition(middle, atBoundary: .word, inDirection: .storage(.backward)))

		XCTAssertTrue(tokenzier.isPosition(end, atBoundary: .word, inDirection: .storage(.forward)))
		XCTAssertFalse(tokenzier.isPosition(end, atBoundary: .word, inDirection: .storage(.backward)))
	}
}
