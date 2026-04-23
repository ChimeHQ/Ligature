import Testing

import Ligature

@MainActor
struct TextTokenizerTests {
	@Test
	func isPositionByWord() throws {
		let input = TextView()
		input.text = "abc def"

		let tokenzier = TextInputStringTokenizer(textInput: input)

		let start = input.beginningOfDocument
		let middle = try #require(input.position(from: start, offset: 1))
		let end = try #require(input.position(from: start, offset: 7))

		#expect(tokenzier.isPosition(start, atBoundary: .word, inDirection: .storage(.forward)) == false)
		#expect(tokenzier.isPosition(start, atBoundary: .word, inDirection: .storage(.backward)))

		#expect(tokenzier.isPosition(middle, atBoundary: .word, inDirection: .storage(.forward)) == false)
		#expect(tokenzier.isPosition(middle, atBoundary: .word, inDirection: .storage(.backward)) == false)

		#expect(tokenzier.isPosition(end, atBoundary: .word, inDirection: .storage(.forward)))
		#expect(tokenzier.isPosition(end, atBoundary: .word, inDirection: .storage(.backward)) == false)
	}

	@Test
	func positionByCharacter() throws {
		let input = TextView()
		input.text = "abc def"

		let tokenzier = TextInputStringTokenizer(textInput: input)

		let start = input.beginningOfDocument
		let end = try #require(input.position(from: start, offset: 7))

		#expect(tokenzier.position(from: start, toBoundary: .character, inDirection: .storage(.backward)) == nil)
		#expect(tokenzier.position(from: start, toBoundary: .character, inDirection: .layout(.left)) == nil)

		let pos1 = try #require(tokenzier.position(from: start, toBoundary: .character, inDirection: .storage(.forward)))
		#expect(input.offset(from: start, to: pos1) == 1)

#if os(macOS) && !targetEnvironment(macCatalyst)
		// why does this produce a nil on iOS?
		let pos2 = try #require(tokenzier.position(from: start, toBoundary: .character, inDirection: .layout(.right)))
		#expect(input.offset(from: start, to: pos2) == 1)
#endif

		#expect(tokenzier.position(from: end, toBoundary: .character, inDirection: .storage(.forward)) == nil)
#if os(macOS) && !targetEnvironment(macCatalyst)
		// why does this *not* produce a nil on iOS?
		#expect(tokenzier.position(from: end, toBoundary: .character, inDirection: .layout(.right)) == nil)
#endif

		let pos3 = try #require(tokenzier.position(from: end, toBoundary: .character, inDirection: .storage(.backward)))
		#expect(input.offset(from: start, to: pos3) == 6)

		let pos4 = try #require(tokenzier.position(from: end, toBoundary: .character, inDirection: .layout(.left)))
		#expect(input.offset(from: start, to: pos4) == 6)
	}

	@Test
	func positionByWord() throws {
		let input = TextView()
		input.text = "abc def"

		let tokenzier = TextInputStringTokenizer(textInput: input)

		let start = input.beginningOfDocument
		let end = try #require(input.position(from: start, offset: 7))

		let pos1 = try #require(tokenzier.position(from: start, toBoundary: .word, inDirection: .storage(.forward)))
		#expect(input.offset(from: start, to: pos1) == 3)

#if os(macOS) && !targetEnvironment(macCatalyst)
		// this produces nil on iOS
		let pos2 = try #require(tokenzier.position(from: start, toBoundary: .word, inDirection: .layout(.right)))
		#expect(input.offset(from: start, to: pos2) == 3)
#else
		let pos2 = try #require(input.position(from: start, offset: 3))
#endif

		// on iOS this stops at word boundaries and does not advance to the next word ending like macOS does
		let pos3 = try #require(tokenzier.position(from: pos2, toBoundary: .word, inDirection: .storage(.forward)))
#if os(macOS) && !targetEnvironment(macCatalyst)
		#expect(input.offset(from: start, to: pos3) == 7)
#else
		#expect(input.offset(from: start, to: pos3) == 4)
#endif

		let pos4 = try #require(tokenzier.position(from: end, toBoundary: .word, inDirection: .storage(.backward)))
		#expect(input.offset(from: start, to: pos4) == 4)

		let pos5 = try #require(tokenzier.position(from: pos4, toBoundary: .word, inDirection: .storage(.backward)))
#if os(macOS) && !targetEnvironment(macCatalyst)
		#expect(input.offset(from: start, to: pos5) == 0)
#else
		#expect(input.offset(from: start, to: pos5) == 3)
#endif

		#expect(tokenzier.position(from: start, toBoundary: .word, inDirection: .storage(.backward)) == nil)
		#expect(tokenzier.position(from: end, toBoundary: .word, inDirection: .storage(.forward)) == nil)
	}
}
