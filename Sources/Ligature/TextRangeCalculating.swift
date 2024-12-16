import Foundation

public protocol TextRangeCalculating<TextRange> {
	associatedtype TextRange: Bounded

	typealias Position = TextRange.Bound

	@MainActor
	var beginningOfDocument: Position { get }
	@MainActor
	var endOfDocument: Position { get }

	@MainActor
	func textRange(from fromPosition: Position, to toPosition: Position) -> TextRange?
	@MainActor
	func position(from position: Position, offset: Int) -> Position?
	@MainActor
	func position(from position: Position, in direction: TextLayoutDirection, offset: Int) -> Position?
	@MainActor
	func offset(from: Position, to toPosition: Position) -> Int

	@MainActor
	func compare(_ position: Position, to other: Position) -> ComparisonResult
}

extension TextRangeCalculating {
	@MainActor
	public func textRange(from range: NSRange) -> TextRange? {
		guard
			let start = position(from: beginningOfDocument, offset: range.location),
			let end = position(from: start, offset: range.length)
		else {
			return nil
		}

		return textRange(from: start, to: end)
	}
}

#if os(macOS)
import AppKit

extension NSTextView: TextRangeCalculating {
	public var beginningOfDocument: TextPosition {
		UTF16TextPosition(value: 0)
	}

	public var endOfDocument: TextPosition {
		UTF16TextPosition(value: textStorage?.length ?? 0)
	}

	public func textRange(from fromPosition: TextPosition, to toPosition: TextPosition) -> TextRange? {
		TextRange(start: fromPosition, end: toPosition)
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

extension UITextView: TextRangeCalculating {
}

#endif

extension TextRangeCalculating {
	@MainActor
	public func textRange(offseting range: TextRange, by offset: Int) -> TextRange? {
		guard
			let start = position(from: range.lowerBound, offset: offset),
			let end = position(from: range.upperBound, offset: offset)
		else {
			return nil
		}

		return textRange(from: start, to: end)
	}
}
