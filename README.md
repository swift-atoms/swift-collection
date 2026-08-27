# Collection

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Indexed-collection protocol family for Swift — `Collection.Protocol` with `~Copyable` element support, a single `Collection.Protocol` → `Bidirectional` → `Access.Random` traversal hierarchy, and small protocol-extension surfaces such as `.forEach`, `.count`, and `.first`.

Stdlib's `Swift.Collection` requires `Element: Copyable` (per SE-0427): its `subscript(position) -> Element { get }` accessor returns an owned value, which closes the protocol off to `~Copyable` conformers and `~Copyable` elements. `Collection.Protocol` in this package declares `associatedtype Element: ~Copyable` and a `subscript(position) -> Element { get }` that conformers satisfy with a `_read` (borrowing) accessor — the element is yielded in place, never moved out — so move-only containers and containers of move-only elements reach the same index-navigation and terminal-operation surface as `Copyable` ones.

This package is part of **Story 2 of the data-structures cohort** (`data-structures-launch-2026`). Its native core depends only on comparison for index ordering and iterator for the `Iterable` protocol family. A conformer chooses its own comparable index type; collection does not prescribe a derived typed-index representation.

---

## Quick Start

```swift
import Collection

typealias NumbersIterator = Iterator.Chunk<Int>

// Conform a container to Collection.Protocol — startIndex, endIndex,
// subscript, index(after:) are the four primitives.
struct Numbers: Collection.`Protocol` {
    var storage: [Int]

    var startIndex: Int { 0 }
    var endIndex: Int { storage.count }
    subscript(position: Int) -> Int { storage[position] }
    func index(after i: Int) -> Int { i + 1 }

    func makeIterator() -> NumbersIterator {
        NumbersIterator(storage.span)
    }
}

let numbers = Numbers(storage: [3, 1, 4, 1, 5, 9, 2, 6])

let total = numbers.count  // 8
let first = numbers.first  // Optional(3)

numbers.forEach { element in
    print(element)
}
```

For `~Copyable` element types — file descriptors, unique resource handles, `Span<T>` — conform to `Collection.Protocol` with `associatedtype Element: ~Copyable`. Navigation and borrowing iteration remain available; value-returning conveniences such as `.first` are constrained to `Element: Copyable`.

---

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-collection.git", branch: "main"),
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Collection", package: "swift-collection"),
    ]
)
```

The package is pre-1.0 — until 0.1.0 is tagged, depend on `branch: "main"` rather than `from: "0.1.0"`. Requires Swift 6.4 and macOS 27 / iOS 27 / tvOS 27 / watchOS 27 / visionOS 27 (or the matching Linux / Windows toolchain).

---

## Architecture

Three library products preserve the canonical atom shape:

| Product | When to import | What's in it |
|---------|---------------|--------------|
| `Collection` | Default for application code | Foundation-free native protocol family and `Collection.Rotated`. |
| `Collection Standard Library Integration` | Standard-library seams | Dedicated home for bridges involving standard-library collection protocols. |
| `Collection Apple Foundation Integration` | Apple Foundation seams | The only target that imports Foundation. |

`Collection` is the supported default for consumer code. The core and standard-library integration targets are Foundation-free; Foundation is confined to `Collection Apple Foundation Integration`.

### A single index hierarchy

`Collection.Protocol` is the single root of the index hierarchy. `Collection.Bidirectional` refines it (adding `index(before:)`), and `Collection.Access.Random` refines `Collection.Bidirectional` (adding the O(1)-index-arithmetic guarantee):

```
Collection.Protocol      ← Element, Index, startIndex, endIndex, subscript, index(after:)
      ↑
Collection.Bidirectional ← index(before:)
      ↑
Collection.Access.Random ← O(1) guarantee
```

`~Copyable` element support comes from `Collection.Protocol` itself: it declares `associatedtype Element: ~Copyable`, and its `subscript(position:) -> Element { get }` is satisfied by a `_read` (borrowing) accessor that yields the element in place rather than moving it out. So the `Bidirectional` and `Access.Random` refinements work for containers of move-only elements without any separate navigation root. (An earlier design carried a separate bare-index-navigation protocol — no `Element`, no `subscript` — to dodge a presumed `Copyable` gate on `subscript { get }`; it proved redundant, because the `_read` subscript already avoids that gate, and was removed.)

`Collection.Protocol` refines `Iterable` (the multi-pass / borrow attachable), so every conformer vends a span-based `makeIterator()` and inherits the `Iterable` terminals (`.forEach`, `.reduce`, `.contains`, `.first`) for free. It does **not** refine `Sequenceable` (the single-pass / consuming attachable) — that is an orthogonal capability. Bridging to `Swift.Collection` or `for-in` additionally needs a `Swift.Sequence`-compatible `makeIterator()`, since the `Iterable` witness is a borrowing *chunk* iterator rather than a scalar `Swift.IteratorProtocol`.

### Core protocol extensions

Conformers provide `startIndex`, `endIndex`, `subscript`, `index(after:)`, and the `Iterable` iterator witness. The package derives `.count` from navigation, `.first` for copyable elements, and the iterator terminals supplied by `swift-iterator`.

---

## `~Copyable` element support

`Collection.Protocol` declares `associatedtype Element: ~Copyable`, and its `subscript(position:) -> Element { get }` may be satisfied by a `_read` borrowing accessor. The `Bidirectional` and `Access.Random` refinements inherit that support directly. Operations returning owned elements, such as `.first`, constrain `Element` to `Copyable`.

For self-slicing containers, `Collection.Slice.Protocol` adds `subscript(bounds: Range<Index>) -> Self`. The package provides partial-range subscripts (`self[i...]`, `self[..<i]`) as defaults via a two-tier pattern: a `~Copyable`-safe borrowing tier via `_read`, and a `Copyable` tier that returns owned values via `get`.

---

## `Collection.Rotated`

`Collection.Rotated<Base>` is a zero-copy rotated view over a `Swift.RandomAccessCollection`. Its `Int` rotation offset is normalized modulo the base count (negative offsets rotate in the opposite direction), and the view itself conforms to `Swift.RandomAccessCollection`.

```swift
let original = ["a", "b", "c", "d"]
let rotated = Collection.Rotated(base: original, startOffset: 1)
print(Array(rotated))  // ["b", "c", "d", "a"]
```

The type is hoisted to module level as `__CollectionRotated` and re-exported as `Collection.Rotated` via typealias — Swift does not currently permit nested types inside protocols, and the typealias keeps the namespaced call-site form intact.

---

## Platform Support

| Platform | CI | Status |
|----------|-----|--------|
| macOS 27 | Yes | Full support |
| iOS / tvOS / watchOS / visionOS | — | Supported |
| Linux | Yes | Full support |
| Windows | Yes | Full support |
| Swift Embedded | — | Possible (no Foundation, no concurrency surface; first-party Embedded matrix runs post-flip) |

---

## Stability

Pre-1.0. The public API of `Collection.Protocol` and its members may change while the package remains on `branch: "main"`; consumers should expect breaking changes to surface in commit messages until the first tag. Once tagged, the package follows institute SemVer: post-1.0 breaking changes ship behind a major bump.

| Surface | 0.1.x expectation |
|---|---|
| Public type names (`Collection.Protocol`, `Collection.Bidirectional`, `Collection.Access.Random`, `Collection.Slice.Protocol`, `Collection.Rotated`) | Stable within 0.1.x |
| Documented initializers and accessors | Stable within 0.1.x |
| Internal storage shapes and the hoisted `__CollectionRotated` backing | Not part of the source-stability commitment |

The single index hierarchy (`Collection.Protocol` → `Collection.Bidirectional` → `Collection.Access.Random`, described in [A single index hierarchy](#a-single-index-hierarchy)) is the 0.1.0 shape. An earlier design split bare index navigation into a separate parallel protocol; that split proved redundant — `Collection.Protocol`'s `_read` subscript already carries `~Copyable` support — and was removed.

---

## Related Packages

Direct dependencies (all already-public):

- [swift-comparison](https://github.com/swift-atoms/swift-comparison) — `Comparison.Protocol`, the `Comparable`-shape conformance the `Collection.Protocol` `Index` associated type requires.
- [swift-iterator](https://github.com/swift-atoms/swift-iterator) — the `Iterable` protocol, borrowing chunk iterator, and inherited iteration terminals.

Cohort siblings (Story 2 — Typed indexing and sequences):

- order, index, sequence, **collection**, input, cyclic, vector — see [`data-structures-launch-2026`](https://github.com/swift-institute) for the cohort narrative.

Story 1 sibling primitives ([`cardinal`](https://github.com/swift-atoms/swift-cardinal), [`ordinal`](https://github.com/swift-atoms/swift-ordinal), [`affine`](https://github.com/swift-atoms/swift-affine)) shipped 2026-05-12 and supply the counting / position / displacement primitives the index hierarchy is built on.

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public release.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
