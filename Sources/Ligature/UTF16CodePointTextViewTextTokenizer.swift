#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if os(macOS) || os(iOS) || os(visionOS)

import Glyph

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
	private let textView: TextView

#if os(macOS)
	public init(textView: NSTextView) {
		self.textView = textView
	}
	#else
	public init(textView: UITextView) {
		self.textView = textView
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

			// moving to the very last position is always allowed and requires no checks
			if position + 1 >= maximum {
				return maximum
			}

			let pos = min(position + 1, maximum - 1)

			let charRange = (storage.string as NSString).rangeOfComposedCharacterSequence(at: pos)
			if charRange.lowerBound == pos {
				return pos
			}

			return charRange.upperBound
		case (.character, .storage(.backward)):
			guard let storage else { return position }

			let pos = max(position - 1, 0)

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
#if os(macOS)
		case (.character, .layout(.down)):
			guard
				let alignment = alignment ?? boundingRect(for: NSRange(position..<position))?.origin.x,
				let nextFragment = textContainer?.lineFragment(for: position, offset: 1)
			else {
				return nil
			}

			return textView.characterIndexForInsertion(at: CGPoint(x: alignment, y: nextFragment.0.midY))
		case (.character, .layout(.up)):
			// because we are iterating backwards, we have to advance by one character so we are sure we
			// include the fragment that "position" is in
			guard
				let alignment = alignment ?? boundingRect(for: NSRange(position..<position))?.origin.x,
				let start = self.position(from: position, toBoundary: .character, inDirection: .storage(.forward)),
				let nextFragment = textContainer?.lineFragment(for: start, offset: -1)
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
}

extension UTF16CodePointTextViewTextTokenizer : TextTokenizer {
	public typealias TextRange = NSRange

	public func position(
		from position: Position,
		toBoundary granularity: TextGranularity,
		inDirection direction: TextDirection
	) -> Position? {
		self.position(from: position, toBoundary: granularity, inDirection: direction, alignment: nil)
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
