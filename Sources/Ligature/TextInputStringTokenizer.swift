import Foundation
#if os(macOS)
import AppKit

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
		guard let position = position as? UTF16TextPosition else { return nil }

		let maximum = self.textInput.textStorage?.length ?? 0
		let forward = direction.textStorageDirection(with: textInput.userInterfaceLayoutDirection) == .forward

		switch (granularity, direction) {
		case (.character, .storage(.forward)):
			return position.offsetPosition(by: 1, maximum: maximum)
		case (.character, .storage(.backward)):
			return position.offsetPosition(by: -1, maximum: maximum)

		case (.character, .layout(.left)), (.character, .layout(.right)):
			let offset = forward ? 1 : -1

			return position.offsetPosition(by: offset, maximum: maximum)
		default:
			break
		}

		return nil
	}
	
	public func rangeEnclosingPosition(_ position: Position, with granularity: TextGranularity, inDirection direction: TextDirection) -> TextRange? {
		return nil
	}

	public func isPosition(_ position: Position, atBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
        guard let position = position as? UTF16TextPosition else { return false }

        let string = (textInput.attributedString().string as NSString)
		let forward = direction.textStorageDirection(with: textInput.userInterfaceLayoutDirection) == .forward
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
