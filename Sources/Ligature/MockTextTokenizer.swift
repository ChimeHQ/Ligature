public final class MockTextTokenizer<R: Equatable & Bounded>: TextTokenizer where R.Bound: Equatable {
	public typealias TextRange = R

	public enum Request: Equatable {
		case position(Position, TextGranularity, TextDirection)
	}

	public enum Response: Equatable {
		case position(Position?)
		case rangeEnclosingPosition(R?)
	}

	public private(set) var requests: [Request] = []
	public var responses: [Response] = []

	public init() {
	}

	public func closestMatchingVerticalLocation(to location: Int, above: Bool) -> Int? {
		return nil
	}

	public func position(from position: Position, toBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Position? {
		requests.append(.position(position, granularity, direction))

		switch responses.removeFirst() {
		case let .position(value):
			return value
		default:
			fatalError("wrong return type")
		}
	}

	public func rangeEnclosingPosition(_ position: Position, with granularity: TextGranularity, inDirection direction: TextDirection) -> R? {
		return nil
	}

	public func isPosition(_ position: Position, atBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
		return false
	}

	public func isPosition(_ position: Position, withinTextUnit granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
		return false
	}
}
