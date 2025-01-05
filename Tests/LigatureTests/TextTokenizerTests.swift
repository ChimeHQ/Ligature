import XCTest
#if os(macOS)
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
	func testIsPositionByWord() throws {
		let input = TextView()
		input.text = "abc def"

		let tokenzier = TextInputStringTokenizer(textInput: input)

		let start = input.beginningOfDocument
		let middle = try XCTUnwrap(input.position(from: start, offset: 1))
		let end = try XCTUnwrap(input.position(from: start, offset: 7))

		XCTAssertFalse(tokenzier.isPosition(start, atBoundary: .word, inDirection: .storage(.forward)))
		XCTAssertTrue(tokenzier.isPosition(start, atBoundary: .word, inDirection: .storage(.backward)))

		XCTAssertFalse(tokenzier.isPosition(middle, atBoundary: .word, inDirection: .storage(.forward)))
		XCTAssertFalse(tokenzier.isPosition(middle, atBoundary: .word, inDirection: .storage(.backward)))

		XCTAssertTrue(tokenzier.isPosition(end, atBoundary: .word, inDirection: .storage(.forward)))
		XCTAssertFalse(tokenzier.isPosition(end, atBoundary: .word, inDirection: .storage(.backward)))
	}

	@MainActor
	func testPositionByCharacter() throws {
		let input = TextView()
		input.text = "abc def"

		let tokenzier = TextInputStringTokenizer(textInput: input)

		let start = input.beginningOfDocument
		let end = try XCTUnwrap(input.position(from: start, offset: 7))

		XCTAssertNil(tokenzier.position(from: start, toBoundary: .character, inDirection: .storage(.backward)))
		XCTAssertNil(tokenzier.position(from: start, toBoundary: .character, inDirection: .layout(.left)))

		let pos1 = try XCTUnwrap(tokenzier.position(from: start, toBoundary: .character, inDirection: .storage(.forward)))
		XCTAssertEqual(input.offset(from: start, to: pos1), 1)

#if os(macOS)
		// why does this produce a nil on iOS?
		let pos2 = try XCTUnwrap(tokenzier.position(from: start, toBoundary: .character, inDirection: .layout(.right)))
		XCTAssertEqual(input.offset(from: start, to: pos2), 1)
#endif

		XCTAssertNil(tokenzier.position(from: end, toBoundary: .character, inDirection: .storage(.forward)))
#if os(macOS)
		// why does this *not* produce a nil on iOS?
		XCTAssertNil(tokenzier.position(from: end, toBoundary: .character, inDirection: .layout(.right)))
#endif

		let pos3 = try XCTUnwrap(tokenzier.position(from: end, toBoundary: .character, inDirection: .storage(.backward)))
		XCTAssertEqual(input.offset(from: start, to: pos3), 6)

		let pos4 = try XCTUnwrap(tokenzier.position(from: end, toBoundary: .character, inDirection: .layout(.left)))
		XCTAssertEqual(input.offset(from: start, to: pos4), 6)
	}
}
