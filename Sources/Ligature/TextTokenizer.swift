import Rearrange

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
	typealias PositionComparator = (Position, Position) -> Bool

	func position(from position: Position, toBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Position?
	func rangeEnclosingPosition(_ position: Position, with granularity: TextGranularity, inDirection direction: TextDirection) -> TextRange?

	func isPosition(_ position: Position, atBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Bool
	func isPosition(_ position: Position, withinTextUnit granularity: TextGranularity, inDirection direction: TextDirection) -> Bool
}

#if canImport(UIKit)
extension UITextInputStringTokenizer : TextTokenizer {}
#endif

extension TextTokenizer {
	public func range<RangeCalculator: TextRangeCalculating>(
		from range: TextRange,
		to granularity: TextGranularity,
		in direction: TextDirection,
		rangeCalculator: RangeCalculator
	) -> TextRange? where RangeCalculator.TextRange == TextRange {
		guard let start = position(from: range.lowerBound, toBoundary: granularity, inDirection: direction) else {
			return nil
		}

		if rangeCalculator.compare(range.lowerBound, to: range.upperBound) == .orderedSame {
			return rangeCalculator.textRange(from: start, to: start)
		}

		guard let end = position(from: range.upperBound, toBoundary: granularity, inDirection: direction) else {
			return nil
		}

		return rangeCalculator.textRange(from: start, to: end)
	}
}
