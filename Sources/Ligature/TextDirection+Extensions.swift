extension TextLayoutDirection {
	public func textStorageDirection(with layout: UserInterfaceLayoutDirection) -> TextStorageDirection? {
		switch (self, layout) {
		case (.left, .leftToRight), (.right, .rightToLeft):
			return .backward
		case (.left, .rightToLeft), (.right, .leftToRight):
			return .forward
		case (.down, _), (.up, _):
			return nil
		@unknown default:
			return nil
		}
	}
}

extension TextDirection {
	public func textStorageDirection(with layout: UserInterfaceLayoutDirection) -> TextStorageDirection? {
		switch rawValue {
		case TextStorageDirection.forward.rawValue:
			return .forward
		case TextStorageDirection.backward.rawValue:
			return .backward
		default:
			return TextLayoutDirection(rawValue: rawValue)?.textStorageDirection(with: layout)
		}
	}
}
