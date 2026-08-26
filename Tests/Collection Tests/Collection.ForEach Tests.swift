import Collection_Test_Support
import Index
import Iterable
import Testing

@testable import Collection

extension Collection {
    @Suite
    struct `ForEach Test` {
        @Suite struct Inherited {}
    }
}

extension Collection.`ForEach Test`.Inherited {

    @Test
    func `inherited forEach visits every element in order`() {
        let source = Collection.Fixture.Source([1, 2, 3])

        var collected: [Int] = []
        source.forEach { collected.append($0) }

        #expect(collected == [1, 2, 3])
    }

    @Test
    func `inherited forEach is non-destructive (multipass)`() {
        let source = Collection.Fixture.Source([1, 2])

        var first: [Int] = []
        source.forEach { first.append($0) }
        var second: [Int] = []
        source.forEach { second.append($0) }

        #expect(first == [1, 2])
        #expect(second == [1, 2])
    }

    @Test
    func `inherited forEach over an empty collection visits nothing`() {
        let source = Collection.Fixture.Source<Int>([])

        var collected: [Int] = []
        source.forEach { collected.append($0) }

        #expect(collected.isEmpty)
    }
}
