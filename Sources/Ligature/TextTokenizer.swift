#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@MainActor
public protocol TextTokenizer<TextRange> {
	associatedtype TextRange: Bounded

	typealias Position = TextRange.Bound
	typealias RangeBuilder = (Position, Position) -> TextRange?

	func position(from position: Position, toBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Position?
	func rangeEnclosingPosition(_ position: Position, with granularity: TextGranularity, inDirection direction: TextDirection) -> TextRange?

	func isPosition(_ position: Position, atBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Bool
	func isPosition(_ position: Position, withinTextUnit granularity: TextGranularity, inDirection direction: TextDirection) -> Bool
}

#if canImport(UIKit)
extension UITextInputStringTokenizer : TextTokenizer {}
#endif

extension TextTokenizer {
	public func range(
		from range: TextRange,
		to granularity: TextGranularity,
		in direction: TextDirection,
		rangeBuilder: RangeBuilder
	) -> TextRange? {
		let components = (range.lowerBound, range.upperBound)

		guard
			let start = position(from: components.0, toBoundary: granularity, inDirection: direction),
			let end = position(from: components.1, toBoundary: granularity, inDirection: direction)
		else {
			return nil
		}

		return rangeBuilder(start, end)
	}
}

extension TextTokenizer where TextRange == NSRange {
	public func range(from range: TextRange, to granularity: TextGranularity, in direction: TextDirection) -> TextRange? {
		self.range(from: range, to: granularity, in: direction, rangeBuilder: { NSRange($0..<$1) })
	}
}

extension TextTokenizer where TextRange == Range<Int> {
	public func range(from range: TextRange, to granularity: TextGranularity, in direction: TextDirection) -> TextRange? {
		self.range(from: range, to: granularity, in: direction, rangeBuilder: { $0..<$1 })
	}
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, macCatalyst 15.0, *)
extension TextTokenizer where TextRange == NSTextRange {
	public func range(from range: TextRange, to granularity: TextGranularity, in direction: TextDirection) -> TextRange? {
		self.range(from: range, to: granularity, in: direction, rangeBuilder: { NSTextRange(location: $0, end: $1) })
	}
}
