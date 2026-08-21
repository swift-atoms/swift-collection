public import Collection_Primitives
public import Index_Primitives
public import Iterable
public import Iterator_Chunk_Primitives

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
    public var startIndex: Index_Primitives.Index<Element> { .zero }

    @inlinable
    public var endIndex: Index_Primitives.Index<Element> {
        Index_Primitives.Index<Element>(_unchecked: Ordinal(UInt(_elements.count)))
    }

    @inlinable
    public subscript(_ position: Index_Primitives.Index<Element>) -> Element {
        _elements[Int(bitPattern: position)]
    }

    @inlinable
    public func index(after i: Index_Primitives.Index<Element>) -> Index_Primitives.Index<Element> {
        i.successor.saturating()
    }
}

extension Collection.Fixture.Source {

    @inlinable
    @_lifetime(borrow self)
    public borrowing func makeIterator() -> Iterator_Chunk_Primitives.Iterator.Chunk<Element> {
        Iterator_Chunk_Primitives.Iterator.Chunk(_elements.span)
    }
}
