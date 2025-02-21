#if os(macOS)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import Rearrange

#if os(macOS) || canImport(UIKit)

extension TextRange : Rearrange.Bounded {
	public nonisolated var lowerBound: TextPosition {
		MainActor.assumeIsolated { start }
	}

	public nonisolated var upperBound: TextPosition {
		MainActor.assumeIsolated { end }
	}
}

#endif
