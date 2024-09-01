#if os(macOS)
import AppKit

public typealias UserInterfaceLayoutDirection = NSUserInterfaceLayoutDirection

open class TextPosition: NSObject {

}

final class UTF16TextPosition: TextPosition {
	let value: Int

	init(value: Int) {
		self.value = value
	}
}

@MainActor
open class TextRange: NSObject {
	var start: TextPosition
	var end: TextPosition

	public override init() {
		self.start = UTF16TextPosition(value: 0)
		self.end = UTF16TextPosition(value: 0)
	}

	var isEmpty: Bool {
		return true
	}
}

/// Matches the implementation of `UITextGranularity`.
public enum TextGranularity : Int, Sendable {
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

public enum TextStorageDirection : Int {
	case forward = 0
	case backward = 1
}

public enum TextLayoutDirection : Int {
	case right = 2
	case left = 3
	case up = 4
	case down = 5
}

/// Matches the implementation of `UITextDirection`.
public struct TextDirection : Hashable, Equatable, RawRepresentable {
	public var rawValue: Int
	
	public init?(rawValue: Int) {
		if rawValue < 0 || rawValue > 5 {
			return nil
		}

		self.rawValue = rawValue
	}

	public static func storage(_ direction: TextStorageDirection) -> TextDirection {
		TextDirection(rawValue: direction.rawValue)!
	}

	public static func layout(_ direction: TextLayoutDirection) -> TextDirection {
		TextDirection(rawValue: direction.rawValue)!
	}
}

typealias TextView = NSTextView

extension NSTextView {
	public var beginningOfDocument: TextPosition {
		UTF16TextPosition(value: 0)
	}

	public func textRange(from fromPosition: TextPosition, to toPosition: TextPosition) -> TextRange? {
		nil
	}

	public func position(from position: TextPosition, offset: Int) -> TextPosition? {
		guard let utf16Position = position as? UTF16TextPosition else { return nil }

		return UTF16TextPosition(value: utf16Position.value + offset)
	}

	public func position(from position: TextPosition, in direction: TextLayoutDirection, offset: Int) -> TextPosition? {
		guard let utf16Position = position as? UTF16TextPosition else { return nil }

		let start = utf16Position.value

		switch (direction, userInterfaceLayoutDirection) {
		case (.left, .leftToRight), (.right, .rightToLeft):
			return UTF16TextPosition(value: start + offset)
		case (.right, .leftToRight), (.left, .rightToLeft):
			return UTF16TextPosition(value: start - offset)
		default:
			return nil
		}
	}

	public func compare(_ position: TextPosition, to other: TextPosition) -> ComparisonResult {
		guard
			let a = position as? UTF16TextPosition,
			let b = other as? UTF16TextPosition
		else {
			return .orderedSame
		}

		if a.value < b.value {
			return .orderedAscending
		}

		if a.value > b.value {
			return .orderedDescending
		}

		return .orderedSame
	}

	public func offset(from: TextPosition, to toPosition: TextPosition) -> Int {
		guard
			let a = from as? UTF16TextPosition,
			let b = toPosition as? UTF16TextPosition
		else {
			return 0
		}

		return b.value - a.value
	}
}

#elseif canImport(UIKit)
import UIKit

public typealias TextPosition = UITextPosition
public typealias TextRange = UITextRange
public typealias TextGranularity = UITextGranularity
public typealias TextStorageDirection = UITextStorageDirection
public typealias TextDirection = UITextDirection
public typealias TextInputStringTokenizer = UITextInputStringTokenizer
public typealias UserInterfaceLayoutDirection = UIUserInterfaceLayoutDirection

#endif

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
@available(watchOS, unavailable)
extension NSTextSelection.Granularity {
	public init(_ granularity: TextGranularity) {
		switch granularity {
		case .character:
			self = .character
		case .paragraph:
			self = .paragraph
		case .word:
			self = .word
		case .sentence:
			self = .sentence
		case .line:
			self = .line
		case .document:
			self = .paragraph
		@unknown default:
			self = .character
		}
	}
}
