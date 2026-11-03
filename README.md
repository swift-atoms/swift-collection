# swift-collection

Use this package when a type gives multipass, index-based access to its elements, including types that are `~Copyable` or hold `~Copyable` elements. Conform to `Collection.Protocol`, then refine to `Collection.Bidirectional`, `Collection.Access.Random`, `Collection.Slice.Protocol` or `Collection.Remove.Last` as far as the type allows. For iteration without indices, conform to `Sequence.Borrowing.Protocol` from swift-sequence instead. To read a standard `RandomAccessCollection` from a different start, wrap it in `Collection.Rotated<Base>`.

## Laws

- `count` is never stored or cached. On every access it walks from `startIndex` to `endIndex` with `index(after:)`, so it costs linear time.
- `max` and `min` scan from `startIndex` and keep the first index among equal extremes. An empty collection has neither. A comparator replaces the element order, so `max(by: .descending)` yields the smallest element.
- `Collection.Rotated<Base>` places the base element at position + offset, modulo the base count, at each position. Its positions count from zero, whatever the base's own indices are. The offset is normalized modulo the base count once, when the value is created. A negative offset counts back from the end, and every `Int` offset, `Int.min` and `Int.max` included, normalizes without overflow. An empty base ignores the offset. Rotating a rotation adds the two offsets.
- A selection (`Search.Selection`, a `Repetition` over a `Predicate`, or a `Cardinal.Range`) called with a collection returns a prefix of that collection as its `SubSequence`. The prefix keeps the input's own indices, including nonzero-based slices, and the input is never mutated.
  - `.start` ends the prefix before the first full occurrence of the delimiter, and `.end` ends it after that occurrence. A partial match that fails does not hide a full match that starts inside it. An empty delimiter selects an empty prefix. A missing delimiter fails.
  - A `Repetition` over a `Predicate` takes leading elements while the predicate holds. A `Cardinal.Range` takes a number of leading elements. Either one fails, reporting how many elements it found, when fewer than the lower bound are available.
- `Tagged` over a `Collection.Protocol` retags indices and `count` to the tag without moving them. A source whose `startIndex` is 7 gives a tagged `startIndex` at 7, and every element is the same one the underlying collection has at that position.
