@MainActor
public protocol TextPositionSpace<Position, TextRange> {
	associatedtype Position
	associatedtype TextRange

	func decomposeRange(_ range: TextRange) -> (Position, Position)
	func composeRange(_ components: (Position, Position)) -> TextRange?
}

extension TextPositionSpace {
	public func composeRange(_ start: Position, _ end: Position) -> TextRange? {
		composeRange((start, end))
	}
}

#if canImport(UIKit)
import UIKit

extension UITextView : TextPositionSpace {
	public func decomposeRange(_ range: TextRange) -> (TextPosition, TextPosition) {
		(range.start, range.end)
	}

	public func composeRange(_ components: (TextPosition, TextPosition)) -> TextRange? {
		textRange(from: components.0, to: components.1)
	}
}

#endif
