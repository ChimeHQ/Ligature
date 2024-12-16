import Foundation

public final class MockRangeCalculator<R: Bounded & Equatable>: TextRangeCalculating where R.Bound == Int {
	public typealias TextRange = R

	private let textRangeBuilder: (Position, Position) -> TextRange?

	public init(textRangeBuilder: @escaping (Position, Position) -> TextRange?) {
		self.textRangeBuilder = textRangeBuilder
	}

	public var beginningOfDocument: Position {
		0
	}

	public var endOfDocument: Position {
		0
	}

	public func textRange(from fromPosition: Position, to toPosition: Position) -> TextRange? {
		textRangeBuilder(fromPosition, toPosition)
	}

	public func position(from position: Position, offset: Int) -> Position? {
		position + offset
	}

	public func position(from position: Position, in direction: Ligature.TextLayoutDirection, offset: Int) -> Position? {
		nil
	}

	public func offset(from: Position, to toPosition: Position) -> Int {
		toPosition - from
	}

	public func compare(_ position: Position, to other: Position) -> ComparisonResult {
		if position < other {
			return .orderedAscending
		}

		if other < position {
			return .orderedDescending
		}

		return .orderedSame
	}
}
