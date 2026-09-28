#if TaggedCollection
import Collection
import Index
import Iterator
import Ordinal
import Tagged
import Testing

private enum Node {}

private typealias ElementIndex<Element: ~Copyable & ~Escapable> = Index<Element>
private typealias SourceIterator<Element: Copyable> = Iterator.Chunk<Element>

private struct IndexedSource<Value: Sendable>: Collection.`Protocol`, Sendable {
    let elements: [Value]
    let base: UInt

    init(_ elements: [Value], base: UInt = 0) {
        self.elements = elements
        self.base = base
    }

    typealias Element = Value

    typealias Index = ElementIndex<Value>

    var startIndex: Index { Index(_unchecked: Ordinal(base)) }

    var endIndex: Index { Index(_unchecked: Ordinal(base + UInt(elements.count))) }

    subscript(position: Index) -> Value {
        elements[Int(position.underlying.rawValue - base)]
    }

    func index(after i: Index) -> Index {
        Index(_unchecked: Ordinal(i.underlying.rawValue + 1))
    }

    @_lifetime(borrow self)
    borrowing func makeIterator() -> SourceIterator<Value> {
        SourceIterator(elements.span)
    }
}

@Suite struct `Tagged Indexed View Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Tagged Indexed View Tests`.Unit {

    @Test func `indexed view over a collection conformer`() {
        let source = IndexedSource([10, 20, 30])
        let nodes = Tagged<Node, IndexedSource<Int>>(_unchecked: source)

        #expect(!nodes.isEmpty)

        var collected: [Int] = []
        var i = nodes.startIndex
        while i < nodes.endIndex {
            collected.append(nodes[i])
            i = nodes.index(after: i)
        }
        #expect(collected == [10, 20, 30])
    }
}


extension `Tagged Indexed View Tests`.`Edge Case` {
    @Test func emptyViewPreservesNonzeroBounds() {
        let nodes = Tagged<Node, IndexedSource<Int>>(IndexedSource([], base: 9))
        #expect(nodes.count == 0)
        #expect(nodes.isEmpty)
        #expect(nodes.startIndex == nodes.endIndex)
        #expect(nodes.startIndex.underlying.rawValue == 9)
    }
}

extension `Tagged Indexed View Tests`.Integration {
    @Test func tagChangesIndexIdentityWithoutChangingSourcePositions() {
        let source = IndexedSource([10, 20, 30], base: 7)
        let nodes = Tagged<Node, IndexedSource<Int>>(source)
        let first: Index<Node> = nodes.startIndex
        let second: Index<Node> = nodes.index(after: first)
        let count: Index<Node>.Count = nodes.count
        #expect(count == 3)
        #expect(first.underlying.rawValue == 7)
        #expect(second.underlying.rawValue == 8)
        #expect(nodes.endIndex.underlying.rawValue == 10)
        #expect(nodes[first] == 10)
        #expect(nodes[second] == 20)
        #expect(source.startIndex.underlying.rawValue == 7)
    }

    @Test func noncopyablePhantomTagDoesNotConstrainStoredCollection() {
        let values = Tagged<OwnedTag, IndexedSource<Int>>(IndexedSource([42]))
        #expect(values[values.startIndex] == 42)
    }
}

private struct OwnedTag: ~Copyable {}
#endif
