import Testing

import Ligature

struct UTF16CodePointTextViewTextTokenizerTests {
	@MainActor
	@Test
	func moveRightToEnd() {
		let input = TextView()
		input.text = "a"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 0, toBoundary: .character, inDirection: .layout(.right))

		#expect(value == 1)
	}

	@MainActor
	@Test
	func moveRightPastEnd() {
		let input = TextView()
		input.text = "a"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 1, toBoundary: .character, inDirection: .layout(.right))

		#expect(value == nil)
	}

	@MainActor
	@Test
	func moveForwardToEnd() {
		let input = TextView()
		input.text = "a"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 0, toBoundary: .character, inDirection: .storage(.forward))

		#expect(value == 1)
	}

	@MainActor
	@Test
	func moveLeftToStart() {
		let input = TextView()
		input.text = "a"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 1, toBoundary: .character, inDirection: .layout(.left))

		#expect(value == 0)
	}

	@MainActor
	@Test
	func moveLeftPastStart() {
		let input = TextView()
		input.text = "a"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 0, toBoundary: .character, inDirection: .layout(.left))

		#expect(value == nil)
	}
}
