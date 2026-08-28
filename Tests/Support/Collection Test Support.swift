public import Collection
public import Index
public import Iterable
public import Iterator_Chunk

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

    @inlinable
    public var startIndex: Index.Index<Element> { .zero }

    @inlinable
    public var endIndex: Index.Index<Element> {
        Index.Index<Element>(_unchecked: Ordinal(UInt(_elements.count)))
    }

    @inlinable
    public subscript(_ position: Index.Index<Element>) -> Element {
        _elements[Int(bitPattern: position)]
    }

    @inlinable
    public func index(after i: Index.Index<Element>) -> Index.Index<Element> {
        i.successor.saturating()
    }
}

extension Collection.Fixture.Source {

    @inlinable
    @_lifetime(borrow self)
    public borrowing func makeIterator() -> Iterator_Chunk.Iterator.Chunk<Element> {
        Iterator_Chunk.Iterator.Chunk(_elements.span)
    }
}
