import Cardinal
import Collection_Test_Support
import Index
import Iterator
import Ordinal
import Tagged
import Testing

@testable import Collection

private final class Steps {
    var taken = 0
}

private struct Stored: Collection.`Protocol` {
    let elements: [Int]
    let steps: Steps

    init(_ elements: [Int]) {
        self.elements = elements
        self.steps = Steps()
    }
}

extension Stored {

    typealias Element = Int

    typealias Index = Index::Index<Int>

    var startIndex: Index { .zero }

    var endIndex: Index { Index(_unchecked: Ordinal(UInt(elements.count))) }

    var count: Index.Count { Index.Count(_unchecked: Cardinal(UInt(elements.count))) }

    subscript(position: Index) -> Int {
        elements[Int(bitPattern: position.underlying.rawValue)]
    }

    func index(after i: Index) -> Index {
        steps.taken += 1
        return i.successor.saturating()
    }

    @_lifetime(borrow self)
    borrowing func makeIterator() -> Iterator::Iterator.Chunk<Int> {
        Iterator::Iterator.Chunk(elements.span)
    }
}

private enum Node {}

private func generic<C: Collection.`Protocol`>(
    _ collection: borrowing C
) -> Index::Index<C.Element>.Count {
    collection.count
}

extension `Collection Tests` {
    @Suite
    struct `A conformer's own count is used wherever the collection is generic` {}
}

extension `Collection Tests`.`A conformer's own count is used wherever the collection is generic` {

    @Test
    func `a generic Collection.Protocol context reads the stored count without stepping`() {
        let stored = Stored(Swift.Array(0..<10_000))
        #expect(generic(stored) == Index::Index<Int>.Count(_unchecked: Cardinal(10_000)))
        #expect(stored.steps.taken == 0)
    }

    #if TaggedCollection
    @Test
    func `a tagged collection reads the stored count without stepping`() {
        let stored = Stored(Swift.Array(0..<10_000))
        let nodes = Tagged<Node, Stored>(_unchecked: stored)
        #expect(nodes.count == Index::Index<Node>.Count(_unchecked: Cardinal(10_000)))
        #expect(stored.steps.taken == 0)
    }
    #endif

    @Test
    func `a conformer without a stored count still counts by stepping`() {
        let source = Collection.Fixture.Source([1, 2, 3])
        #expect(generic(source) == Index::Index<Int>.Count(_unchecked: Cardinal(3)))
    }
}
