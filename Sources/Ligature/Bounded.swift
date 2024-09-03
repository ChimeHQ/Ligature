public protocol Bounded<Bound> {
	associatedtype Bound

	var lowerBound: Bound { get }
	var upperBound: Bound { get }
}

#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@available(iOS 15.0, macOS 12.0, tvOS 15.0, macCatalyst 15.0, *)
extension NSTextRange : Bounded {
	public var lowerBound: NSTextLocation { location }
	public var upperBound: NSTextLocation { endLocation }
}

extension TextRange : Bounded {
	public nonisolated var lowerBound: TextPosition {
		MainActor.assumeIsolated { start }
	}

	public nonisolated var upperBound: TextPosition {
		MainActor.assumeIsolated { end }
	}
}

extension NSRange : Bounded {}

extension Range : Bounded {}
