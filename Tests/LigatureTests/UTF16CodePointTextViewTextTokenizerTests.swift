import Testing

import Ligature

@MainActor
struct UTF16CodePointTextViewTextTokenizerTests {
	@Test
	func moveRightToEnd() {
		let input = TextView()
		input.text = "a"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 0, toBoundary: .character, inDirection: .layout(.right))

		#expect(value == 1)
	}

	@Test
	func moveRightPastEnd() {
		let input = TextView()
		input.text = "a"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 1, toBoundary: .character, inDirection: .layout(.right))

		#expect(value == nil)
	}

	@Test
	func moveForwardToEnd() {
		let input = TextView()
		input.text = "a"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 0, toBoundary: .character, inDirection: .storage(.forward))

		#expect(value == 1)
	}

	@Test
	func moveLeftToStart() {
		let input = TextView()
		input.text = "a"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 1, toBoundary: .character, inDirection: .layout(.left))

		#expect(value == 0)
	}

	@Test
	func moveLeftPastStart() {
		let input = TextView()
		input.text = "a"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 0, toBoundary: .character, inDirection: .layout(.left))

		#expect(value == nil)
	}

	@Test
	func moveForwardByWord() async throws {
		let input = TextView()
		input.text = "abc def"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 0, toBoundary: .word, inDirection: .storage(.forward))

		#expect(value == 3)
	}

	@Test
	func moveForwardByWordJustBeforeNewline() throws {
		let input = TextView()
		input.text = "abc\ndef"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 3, toBoundary: .word, inDirection: .storage(.forward))

		#expect(value == 7)
	}

	@Test
	func moveForwardByWordAtNewlineContainingWhitespace() throws {
		let input = TextView()
		input.text = "abc\n def"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 4, toBoundary: .word, inDirection: .storage(.forward))

		#expect(value == 8)
	}

	@Test
	func moveBackwardsByWord() async throws {
		let input = TextView()
		input.text = "abc def"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 7, toBoundary: .word, inDirection: .storage(.backward))

		#expect(value == 4)
	}

	@Test
	func moveBackwardByWordJustBeforeNewline() throws {
		let input = TextView()
		input.text = "abc\ndef"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 4, toBoundary: .word, inDirection: .storage(.backward))

		#expect(value == 0)
	}

	@Test
	func moveBackwardByWordAtNewlineContainingWhitespace() throws {
		let input = TextView()
		input.text = "abc\n def"

		let tokenizer = UTF16CodePointTextViewTextTokenizer(textView: input)

		let value = tokenizer.position(from: 5, toBoundary: .word, inDirection: .storage(.backward))

		#expect(value == 4)
	}
}
