import Testing

import Collection
import Comparison
import Order
import Ownership
import Property
import Iterator
import Tagged

@Suite("Collection × Property")
struct Collection_Property_Tests {

    @Test("max and min preserve the first matching index")
    func extrema() {
        var source = Source([3, 1, 5, 5])

        #expect(source.max.index() == 2)
        #expect(source.max() == 5)
        #expect(source.min.index() == 1)
        #expect(source.min() == 1)
    }

    @Test("custom order controls extrema")
    func customOrder() {
        var source = Source([3, 1, 5])

        #expect(source.max(by: .descending) == 1)
        #expect(source.min(by: .descending) == 5)
    }

    @Test("empty collections have no extrema")
    func empty() {
        var source = Source<Int>([])

        #expect(source.max.index() == nil)
        #expect(source.max() == nil)
        #expect(source.min.index() == nil)
        #expect(source.min() == nil)
    }

    @Test("slice exposes the same collection value")
    func slice() {
        var source = Source([3, 1, 5])

        #expect(source.slice.base.value[1] == 1)
    }
}

private typealias SourceIterator<Element: ~Copyable> = Iterator.Chunk<Element>

private struct Source<Element: Sendable>: Collection.`Protocol`, Collection.Slice.`Protocol` {
    typealias Iterator = SourceIterator<Element>

    let elements: [Element]

    init(_ elements: [Element]) {
        self.elements = elements
    }

    var startIndex: Int { elements.startIndex }
    var endIndex: Int { elements.endIndex }

    subscript(position: Int) -> Element {
        elements[position]
    }

    subscript(bounds: Range<Int>) -> Self {
        Source(Array(elements[bounds]))
    }

    func index(after index: Int) -> Int {
        elements.index(after: index)
    }

    func makeIterator() -> SourceIterator<Element> {
        SourceIterator(elements.span)
    }
}
