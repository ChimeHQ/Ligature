import Foundation

public struct SourceTokenizer<FallbackTokenzier: TextTokenizer> {
	public typealias Position = FallbackTokenzier.Position

	private let fallbackTokenzier: FallbackTokenzier

	init(fallbackTokenzier: FallbackTokenzier) {
		self.fallbackTokenzier = fallbackTokenzier
	}
}

extension SourceTokenizer : TextTokenizer {
	public func position(from position: Position, toBoundary granularity: TextGranularity, inDirection direction: TextDirection, alignment: CGFloat?) -> Position? {
		return fallbackTokenzier.position(from: position, toBoundary: granularity, inDirection: direction, alignment: alignment)
	}

	public func rangeEnclosingPosition(_ position: Position, with granularity: TextGranularity, inDirection direction: TextDirection) -> FallbackTokenzier.TextRange? {
		return fallbackTokenzier.rangeEnclosingPosition(position, with: granularity, inDirection: direction)
	}

	public func isPosition(_ position: Position, atBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
		return fallbackTokenzier.isPosition(position, atBoundary: granularity, inDirection: direction)
	}

	public func isPosition(_ position: Position, withinTextUnit granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
		return fallbackTokenzier.isPosition(position, withinTextUnit: granularity, inDirection: direction)
	}
}
