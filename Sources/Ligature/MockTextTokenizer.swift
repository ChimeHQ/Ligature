public final class MockTextTokenizer: TextTokenizer {
	public enum Request: Hashable {
		case position(Int, TextGranularity, TextDirection)
	}

	public enum Response: Hashable {
		case position(Int?)
		case rangeEnclosingPosition(Range<Int>?)
	}

	public private(set) var requests: [Request] = []
	public var responses: [Response] = []

	public init() {
	}

	public func closestMatchingVerticalLocation(to location: Int, above: Bool) -> Int? {
		return nil
	}

	public func position(from position: Int, toBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Int? {
		requests.append(.position(position, granularity, direction))

		switch responses.removeFirst() {
		case let .position(value):
			return value
		default:
			fatalError("wrong return type")
		}
	}

	public func rangeEnclosingPosition(_ position: Int, with granularity: TextGranularity, inDirection direction: TextDirection) -> Range<Int>? {
		return nil
	}

	public func isPosition(_ position: Int, atBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
		return false
	}

	public func isPosition(_ position: Int, withinTextUnit granularity: TextGranularity, inDirection direction: TextDirection) -> Bool {
		return false
	}
}
