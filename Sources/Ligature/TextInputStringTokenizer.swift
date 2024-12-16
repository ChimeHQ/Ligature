import Foundation
#if os(macOS)
import AppKit

@MainActor
public struct TextInputStringTokenizer {
	private let internalTokenizer: UTF16CodePointTextViewTextTokenizer

	public init(textInput: NSTextView) {
		self.internalTokenizer = UTF16CodePointTextViewTextTokenizer(textView: textInput)
	}
}

extension TextInputStringTokenizer : TextTokenizer {
	public typealias Position = TextPosition

	public func position(from position: Position, toBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Position? {
		guard let position = position as? UTF16TextPosition else { return nil }

		return internalTokenizer.position(
			from: position.value,
			toBoundary: granularity,
			inDirection: direction
		)
		.map { UTF16TextPosition(value: $0) }
	}
	
	public func rangeEnclosingPosition(_ position: Position, with granularity: TextGranularity, inDirection direction: TextDirection) -> TextRange? {
		guard let position = position as? UTF16TextPosition else { return nil }

		return internalTokenizer.rangeEnclosingPosition(
			position.value,
			with: granularity,
			inDirection: direction
		)
		.map { TextRange($0) }
	}

	public func isPosition(_ position: Position, atBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
        guard let position = position as? UTF16TextPosition else { return false }

		return internalTokenizer.isPosition(position.value, atBoundary: granularity, inDirection: direction)
	}

	public func isPosition(_ position: Position, withinTextUnit granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
		guard let position = position as? UTF16TextPosition else { return false }

		return internalTokenizer.isPosition(position.value, withinTextUnit: granularity, inDirection: direction)
	}
}

#endif
