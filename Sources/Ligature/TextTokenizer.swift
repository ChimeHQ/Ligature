import Foundation

@MainActor
public protocol TextTokenizer<Position, TextRange> {
	associatedtype Position
	associatedtype TextRange

	func position(from position: Position, toBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Position?
	func rangeEnclosingPosition(_ position: Position, with granularity: TextGranularity, inDirection direction: TextDirection) -> TextRange?

	func isPosition(_ position: Position, atBoundary granularity: TextGranularity, inDirection direction: TextDirection) -> Bool
	func isPosition(_ position: Position, withinTextUnit granularity: TextGranularity, inDirection direction: TextDirection) -> Bool
}

#if canImport(UIKit)
import UIKit

extension UITextInputStringTokenizer : TextTokenizer {
}

#endif
