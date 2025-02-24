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

	func position(from position: Position, toBoundary granularity: TextGranularity, inDirection direction: TextDirection, alignment: CGFloat?) -> Position?
	func rangeEnclosingPosition(_ position: Position, with granularity: TextGranularity, inDirection direction: TextDirection) -> TextRange?

	func isPosition(_ position: Position, atBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Bool
	func isPosition(_ position: Position, withinTextUnit granularity: TextGranularity, inDirection direction: TextDirection) -> Bool
}

extension TextTokenizer {
	public func position(from position: Position, toBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Position? {
		self.position(from: position, toBoundary: granularity, inDirection: direction, alignment: nil)
	}
}

#if canImport(UIKit)
extension UITextInputStringTokenizer : TextTokenizer {
	public func position(from position: Position, toBoundary granularity: TextGranularity, inDirection direction: TextDirection, alignment: CGFloat?) -> Position? {
		self.position(from: position, toBoundary: granularity, inDirection: direction)
	}
}
#endif
