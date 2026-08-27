public import Collection
public import Iterator

extension Collection {

    public enum Fixture {}
}

extension Collection.Fixture {

    public struct Source<Element>: Collection.`Protocol`, Sendable
    where Element: Sendable {
        @usableFromInline
        let _elements: [Element]

        @inlinable
        public init(_ elements: [Element]) {
            self._elements = elements
        }
    }
}

extension Collection.Fixture.Source {

    public typealias Index = Int

    @inlinable
    public var startIndex: Index { 0 }

    @inlinable
    public var endIndex: Index {
        _elements.count
    }

    @inlinable
    public subscript(_ position: Index) -> Element {
        _elements[position]
    }

    @inlinable
    public func index(after i: Index) -> Index {
        i + 1
    }
}

extension Collection.Fixture.Source {

    @inlinable
    @_lifetime(borrow self)
    public borrowing func makeIterator() -> Iterator.Chunk<Element> {
        .init(_elements.span)
    }
}
