<div align="center">

[![Build Status][build status badge]][build status]
[![Platforms][platforms badge]][platforms]
[![Documentation][documentation badge]][documentation]
[![Matrix][matrix badge]][matrix]

</div>

# Ligature
A Swift package to aid in text selection, grouping, and manipulation.

Ligature includes aliases and implementations as needed to make parts of the UIKit and AppKit text interfaces source-compatible. The core types actually go futher than this and should be fully text system-agnostic.

You also might be interested in [Glyph][], a TextKit 1/2 abstraction system, as well as general AppKit/UIKit stuff like [NSUI][] or [KeyCodes][].

[Glyph]: https://github.com/ChimeHQ/Glyph
[NSUI]: https://github.com/mattmassicotte/NSUI
[KeyCodes]: https://github.com/ChimeHQ/KeyCodes

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/Ligature", branch: "main")
],
```

## Usage

The core protocol for the tokenization functionality is `TextTokenizer`. It is a little more abstract than `UITextInputTokenizer`, but ultimately compatible. With UIKit, `TextInputStringTokenizer` is just a typealias for `UITextInputStringTokenizer`. Ligature provides an implementation for use with AppKit.

> [!WARNING]
> While quite usable, there are features the `TextTokenizer` API supports that are not fully implemented by the AppKit implementation.

```swift
// on UIKit
let tokenizer = TextInputStringTokenizer(textInput: someUITextView)

// with AppKit
let tokenizer = TextInputStringTokenizer(textInput: someNSTextInputClient)
```

Ligature uses platform-independent aliases to represent many text-related structures. For the most part, these are based on their UIKit representations. Typically, AppKit doesn't have a source-compatible implementation, so wrappers and/or compatible implementations are provided.

```swift
typealias TextPosition = UITextPosition
typealias TextRange = UITextRange
typealias TextGranularity = UITextGranularity
typealias TextStorageDirection = UITextStorageDirection
typealias TextDirection = UITextDirection
typealias UserInterfaceLayoutDirection = UIUserInterfaceLayoutDirection
```

There are a variety of range/position models within AppKit, UIKit, and even between TextKit 1 and 2. Some abstraction is, unfortunately, required to model this, and that is not free. If it is important to operate within `NSRange` values, you can use `UTF16CodePointTextViewTextTokenizer` directly.

## Contributing and Collaboration

I would love to hear from you! Issues or pull requests work great. Both a [Matrix space][matrix] and [Discord][discord] are available for live help, but I have a strong bias towards answering in the form of documentation. You can also find me [here](https://www.massicotte.org/about).

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/ChimeHQ/Ligature/actions
[build status badge]: https://github.com/ChimeHQ/Ligature/workflows/CI/badge.svg
[platforms]: https://swiftpackageindex.com/ChimeHQ/Ligature
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FLigature%2Fbadge%3Ftype%3Dplatforms
[documentation]: https://swiftpackageindex.com/ChimeHQ/Ligature/main/documentation
[documentation badge]: https://img.shields.io/badge/Documentation-DocC-blue
[matrix]: https://matrix.to/#/%23chimehq%3Amatrix.org
[matrix badge]: https://img.shields.io/matrix/chimehq%3Amatrix.org?label=Matrix
[discord]: https://discord.gg/esFpX6sErJ
