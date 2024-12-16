#if os(macOS)
import AppKit

public typealias UserInterfaceLayoutDirection = NSUserInterfaceLayoutDirection

@MainActor
open class TextPosition: NSObject {
}

@MainActor
final class UTF16TextPosition: TextPosition {
	let value: Int

	init(value: Int) {
		self.value = value
	}

	func offsetPosition(by amount: Int, maximum: Int) -> UTF16TextPosition? {
		let new = value + amount
		if new < 0 || new > maximum {
			return nil
		}

		return UTF16TextPosition(value: new)
	}
}

extension UTF16TextPosition {
	public override var debugDescription: String {
		String(value)
	}
}

@MainActor
open class TextRange: NSObject {
	let start: TextPosition
	let end: TextPosition

	public override init() {
		self.start = UTF16TextPosition(value: 0)
		self.end = UTF16TextPosition(value: 0)
	}

	init(start: TextPosition, end: TextPosition) {
		self.start = start
		self.end = end
	}

	init(_ range: NSRange) {
		self.start = UTF16TextPosition(value: range.lowerBound)
		self.end = UTF16TextPosition(value: range.upperBound)
	}

	var isEmpty: Bool {
		return true
	}
}

extension TextRange {
	open override var debugDescription: String {
		MainActor.assumeIsolated {
			"{\(start.debugDescription), \(end.debugDescription)}"
		}
	}

	open override var description: String {
		debugDescription
	}
}

extension NSRange {
	@MainActor
	public init?(_ textRange: TextRange, textView: NSTextView) {
		let location = textView.offset(from: textView.beginningOfDocument, to: textRange.start)
		let length = textView.offset(from: textRange.start, to: textRange.end)

		if location < 0 || length < 0 {
			return nil
		}

		self.init(location: location, length: length)
	}
}

/// Matches the implementation of `UITextGranularity`.
public enum TextGranularity : Int, Sendable, Hashable, Codable {
	case character = 0
	case word = 1
	case sentence = 2
	case paragraph = 3
	case line = 4
	case document = 5
}

extension NSSelectionGranularity {
	public var textGranularity: TextGranularity {
		switch self {
		case .selectByCharacter: .character
		case .selectByParagraph: .paragraph
		case .selectByWord: .word
		@unknown default:
			.character
		}
	}
}

@available(macOS 12.0, *)
extension NSTextSelection.Affinity {
	public init(_ affinity: NSSelectionAffinity) {
		switch affinity {
		case .downstream:
			self = .downstream
		case .upstream:
			self = .upstream
		@unknown default:
			assertionFailure("Unhandled affinity")
			self = .downstream
		}
	}
}

public enum TextStorageDirection : Int, Sendable, Hashable, Codable {
	case forward = 0
	case backward = 1
}

public enum TextLayoutDirection : Int, Sendable, Hashable, Codable {
	case right = 2
	case left = 3
	case up = 4
	case down = 5
}

/// Matches the implementation of `UITextDirection`.
public struct TextDirection : RawRepresentable, Hashable, Sendable {
	public var rawValue: Int
	
	public init(rawValue: Int) {
		if rawValue < 0 || rawValue > 5 {
			fatalError("invalid direction value")
		}

		self.rawValue = rawValue
	}

	public static func storage(_ direction: TextStorageDirection) -> TextDirection {
		TextDirection(rawValue: direction.rawValue)
	}

	public static func layout(_ direction: TextLayoutDirection) -> TextDirection {
		TextDirection(rawValue: direction.rawValue)
	}
}

typealias TextView = NSTextView

#elseif canImport(UIKit)
import UIKit

public typealias TextPosition = UITextPosition
public typealias TextRange = UITextRange
public typealias TextGranularity = UITextGranularity
public typealias TextStorageDirection = UITextStorageDirection
public typealias TextLayoutDirection = UITextLayoutDirection
public typealias TextDirection = UITextDirection
public typealias TextInputStringTokenizer = UITextInputStringTokenizer
public typealias UserInterfaceLayoutDirection = UIUserInterfaceLayoutDirection

typealias TextView = UITextView

#endif
