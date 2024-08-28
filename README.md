<div align="center">

[![Build Status][build status badge]][build status]
[![Platforms][platforms badge]][platforms]
[![Documentation][documentation badge]][documentation]
[![Matrix][matrix badge]][matrix]

</div>

# Ligature
A Swift package to aid in text selection, grouping, indentation, and manipulation.

Ligature includes aliases and implemenations as needed to make parts of the UIKit and AppKit text interfaces source-compatible.

> [!WARNING]
> This is currently very WIP.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/Ligature", branch: "main")
],
```

## Usage

```swift
// on UIKit
let tokenizer = TextInputStringTokenizer(textInput: someUITextView)

// with AppKit
let tokenizer = TextInputStringTokenizer(textInput: someNSTextInputClient)
```

## Contributing and Collaboration

I would love to hear from you! Issues or pull requests work great. Both a [Matrix space][matrix] and [Discord][discord] are available for live help, but I have a strong bias towards answering in the form of documentation. You can also find me on [mastodon](https://mastodon.social/@mattiem).

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
