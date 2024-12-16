#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
@available(watchOS, unavailable)
extension NSTextSelection.Granularity {
	public init(_ granularity: TextGranularity) {
		switch granularity {
		case .character:
			self = .character
		case .paragraph:
			self = .paragraph
		case .word:
			self = .word
		case .sentence:
			self = .sentence
		case .line:
			self = .line
		case .document:
			self = .paragraph
		@unknown default:
			self = .character
		}
	}

	public var textGranularity: TextGranularity {
		switch self {
		case .character:
			.character
		case .line:
			.line
		case .paragraph:
			.paragraph
		case .sentence:
			.sentence
		case .word:
			.word
		@unknown default:
			.character
		}
	}
}
