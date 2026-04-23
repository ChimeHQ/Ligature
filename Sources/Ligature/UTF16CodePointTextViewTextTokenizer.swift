#if os(macOS) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if os(macOS) || os(iOS) || os(tvOS) || os(visionOS)

import Glyph
import Rearrange

extension NSAttributedString {
	func writingDirection(at index: Int) -> NSWritingDirection {
		if index >= length {
			return .natural
		}

		let attrs = attributes(at: index, effectiveRange: nil)
		guard let direction = attrs[.writingDirection] as? NSNumber else {
			return .natural
		}

		return NSWritingDirection(rawValue: direction.intValue) ?? .natural
	}
}

struct Line {
	let start: Int
	let end: Int
	let contentsEnd: Int
}

@MainActor
public struct UTF16CodePointTextViewTextTokenizer {
	public static nonisolated let defaultWordBoundaries: CharacterSet  = .alphanumerics

	private let textView: TextView
	private let wordBoundarySet: CharacterSet

#if os(macOS) && !targetEnvironment(macCatalyst)
	public init(textView: NSTextView, wordBoundaries: CharacterSet = Self.defaultWordBoundaries) {
		self.textView = textView
		self.wordBoundarySet = wordBoundaries
	}
#else
	public init(textView: UITextView, wordBoundaries: CharacterSet = Self.defaultWordBoundaries) {
		self.textView = textView
		self.wordBoundarySet = wordBoundaries
	}
#endif

	private var storage: NSTextStorage? {
		textView.textStorage
	}

	private var textContainer: NSTextContainer? {
		textView.textContainer
	}

	private var maximum: Int {
		storage?.length ?? 0
	}

	private func line(within range: NSRange) -> Line? {
		guard let string = storage?.string as? NSString else {
			return nil
		}

		var start: Int = range.lowerBound
		var end: Int = range.upperBound
		var contentsEnd: Int = range.upperBound

		string.getLineStart(&start, end: &end, contentsEnd: &contentsEnd, for: range)

		return Line(start: start, end: end, contentsEnd: contentsEnd)
	}
}

extension UTF16CodePointTextViewTextTokenizer {
	public func boundingRect(for range: NSRange) -> CGRect? {
		textView.boundingRect(for: range)
	}
	
}

extension UTF16CodePointTextViewTextTokenizer: TextTokenizer {
	public typealias TextRange = NSRange

	/// A variant of position(from:toBoundary:inDirection:) that can take alignment into account.
	public func position(
		from position: Position,
		toBoundary granularity: TextGranularity,
		inDirection direction: TextDirection,
		alignment: CGFloat?
	) -> Position? {
		switch (granularity, direction) {
		case (.character, .storage(.forward)):
			guard let storage else { return position }

			if position >= maximum {
				return nil
			}

			let pos = position + 1
			if pos == maximum {
				// character composition doesn't have to be checked in this case
				return maximum
			}

			let charRange = (storage.string as NSString).rangeOfComposedCharacterSequence(at: pos)
			if charRange.lowerBound == pos {
				return pos
			}

			return charRange.upperBound
		case (.character, .storage(.backward)):
			guard let storage else { return position }

			if position <= 0 {
				return nil
			}

			let pos = position - 1
			if pos == 0 {
				return 0
			}

			let charRange = (storage.string as NSString).rangeOfComposedCharacterSequence(at: pos)

			return charRange.lowerBound
		case (.line, .storage(.forward)):
			guard let fragment = textContainer?.lineFragment(for: position, offset: 0) else {
				return nil
			}

			let fragmentRange = fragment.1

			return line(within: fragmentRange)?.contentsEnd
		case (.line, .storage(.backward)):
			guard let fragment = textContainer?.lineFragment(for: position, offset: 0) else {
				return nil
			}

			let fragmentRange = fragment.1

			return line(within: fragmentRange)?.start
		case (.word, .storage(.forward)):
			guard let storage else { return position }

			if position >= maximum {
				return nil
			}

			let pos = position + 1

			if pos == maximum {
				return maximum
			}

			let set = wordBoundarySet.inverted
			let range = NSRange(pos..<maximum)
			let charRange = (storage.string as NSString).rangeOfCharacter(from: set, range: range)

			if charRange.lowerBound == NSNotFound {
				return maximum
			}

			return charRange.lowerBound
		case (.word, .storage(.backward)):
			guard let storage else { return position }

			if position <= 0 {
				return nil
			}

			let pos = position - 1
			if pos == 0 {
				return 0
			}

			let set = wordBoundarySet.inverted
			let range = NSRange(0..<pos)
			let charRange = (storage.string as NSString).rangeOfCharacter(from: set, options: .backwards, range: range)

			if charRange.lowerBound == NSNotFound {
				return 0
			}

			return charRange.upperBound
		case (_, .layout(.left)):
			guard let storage else { return position }

			let rtl = storage.writingDirection(at: position) == .rightToLeft
			let resolvedDir: TextDirection = rtl ? .storage(.forward) : .storage(.backward)

			return self.position(from: position, toBoundary: granularity, inDirection: resolvedDir, alignment: alignment)
		case (_, .layout(.right)):
			guard let storage else { return position }

			let rtl = storage.writingDirection(at: position) == .rightToLeft
			let resolvedDir: TextDirection = rtl ? .storage(.backward) : .storage(.forward)

			return self.position(from: position, toBoundary: granularity, inDirection: resolvedDir, alignment: alignment)
#if os(macOS) && !targetEnvironment(macCatalyst)
		case (.character, .layout(.down)):
			guard
				let alignment = alignment ?? boundingRect(for: NSRange(position..<position))?.origin.x,
				let nextFragment = textContainer?.lineFragment(for: position, offset: 1)
			else {
				return nil
			}

			return textView.characterIndexForInsertion(at: CGPoint(x: alignment, y: nextFragment.0.midY))
		case (.character, .layout(.up)):
			guard
				let alignment = alignment ?? boundingRect(for: NSRange(position..<position))?.origin.x,
				let nextFragment = textContainer?.lineFragment(for: position, offset: -1)
			else {
				return nil
			}

			return textView.characterIndexForInsertion(at: CGPoint(x: alignment, y: nextFragment.0.midY))
#endif
		default:
			break
		}

		return nil
	}

	public func rangeEnclosingPosition(
		_ position: Position,
		with granularity: TextGranularity,
		inDirection direction: TextDirection
	) -> TextRange? {
		return nil
	}

	public func isPosition(
		_ position: Position,
		atBoundary granularity: TextGranularity,
		inDirection direction: TextDirection
	) -> Bool {
		let forward = storage?.writingDirection(at: position) != .rightToLeft
		let start = forward ? max(position - 1, 0) : 0
		let end = forward ? maximum - 1 : min(position + 1, maximum - 1)
		let options: NSString.EnumerationOptions

		// shortcuts - this are always at boundaries by definition
		switch direction {
		case .storage(.forward):
			if position == maximum {
				return true
			}
		case .storage(.backward):
			if position <= 0 {
				return true
			}
		default:
			break
		}

		switch granularity {
		case .character:
			options = [.byComposedCharacterSequences]
		case .word:
			options = [.byWords]
		case .line:
			options = [.byLines]
		case .sentence:
			options = [.bySentences]
		case .paragraph:
			options = [.byParagraphs]
		case .document:
			return false
		@unknown default:
			return false
		}

		var atBoundary = false

		guard let string = (storage?.string as? NSString) else {
			return false
		}

		string.enumerateSubstrings(in: NSRange(start..<end), options: options) { _, subRange, _, stop in
			let boundary = forward ? subRange.upperBound : subRange.lowerBound

			atBoundary = position == boundary

			stop.pointee = true
		}

		return atBoundary
	}

	public func isPosition(
		_ position: Position,
		withinTextUnit granularity: TextGranularity,
		inDirection direction: TextDirection
	) -> Bool {
		return false
	}
}
#endif
