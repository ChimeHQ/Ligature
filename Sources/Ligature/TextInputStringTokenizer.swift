import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
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
		return false
	}

	public func isPosition(_ position: Position, withinTextUnit granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
		return false
	}
}

#endif
