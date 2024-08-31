import Foundation
#if os(macOS)
import AppKit

extension NSTextView {
	func isForwardDirection(_ direction: TextDirection) -> Bool {
		switch direction {
		case .storage(.forward):
			return true
		case .layout(.right):
			return userInterfaceLayoutDirection == .leftToRight
		case .layout(.left):
			return userInterfaceLayoutDirection == .rightToLeft
		default:
			return false
		}
	}
}

@MainActor
public final class TextInputStringTokenizer {
	private let textInput: NSTextView

	public init(textInput: NSTextView) {
		self.textInput = textInput
	}
}

extension TextInputStringTokenizer : TextTokenizer {
	public typealias Position = TextPosition

	public func position(from position: Position, toBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Position? {
		return nil
	}
	
	public func rangeEnclosingPosition(_ position: Position, with granularity: TextGranularity, inDirection direction: TextDirection) -> TextRange? {
		return nil
	}

	public func isPosition(_ position: Position, atBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
        guard let position = position as? UTF16TextPosition else { return false }

        let string = (textInput.attributedString().string as NSString)
        let forward = textInput.isForwardDirection(direction)
        let start = forward ? max(position.value - 1, 0) : 0
        let end = forward ? string.length : min(position.value + 1, string.length)
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
        }

        var atBoundary = false

        string.enumerateSubstrings(in: NSRange(start..<end), options: options) { _, subRange, _, stop in
            let boundary = forward ? subRange.upperBound : subRange.lowerBound

            atBoundary = position.value == boundary

            stop.pointee = true
        }

		return atBoundary
	}

	public func isPosition(_ position: Position, withinTextUnit granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
		return false
	}
}

#endif
