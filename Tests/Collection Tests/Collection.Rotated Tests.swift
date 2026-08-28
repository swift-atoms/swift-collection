import Affine_Carrier
import Affine_Tagged
import Cardinal
import Cardinal_Carrier
import Index
import Ordinal
import Ordinal_Cardinal
import Ordinal_Protocol
import Ordinal_Tagged
import Tagged
import Testing

private func count<Element>(
    _ rawValue: UInt,
    for _: Element.Type
) -> Index::Index<Element>.Count {
    Index::Index<Element>.Count(_unchecked: Cardinal::Cardinal(rawValue))
}

@testable import Collection

extension Collection {
    @Suite
    struct `Rotated Test` {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension Collection.`Rotated Test`.Unit {

    @Test
    func `rotation by 0 returns original order`() {
        let original = ["a", "b", "c", "d"]
        let rotated = Collection.Rotated(base: original, startOffset: .zero)

        #expect(Array(rotated) == ["a", "b", "c", "d"])
    }

    @Test
    func `rotation by 1 shifts elements left`() {
        let original = ["a", "b", "c", "d"]
        let rotated = Collection.Rotated(base: original, startOffset: .one)

        #expect(Array(rotated) == ["b", "c", "d", "a"])
    }

    @Test
    func `rotation by 2 shifts elements left by 2`() {
        let original = ["a", "b", "c", "d"]
        let rotated = Collection.Rotated(
            base: original,
            startOffset: Index::Index<String>.Offset(2)
        )

        #expect(Array(rotated) == ["c", "d", "a", "b"])
    }

    @Test
    func `rotation by count returns original order`() {
        let original = ["a", "b", "c", "d"]
        let rotated = Collection.Rotated(
            base: original,
            startOffset: Index::Index<String>.Offset(4)
        )

        #expect(Array(rotated) == ["a", "b", "c", "d"])
    }

    @Test
    func `rotation normalizes offset modulo count`() {
        let original = ["a", "b", "c", "d"]
        let rotated = Collection.Rotated(
            base: original,
            startOffset: Index::Index<String>.Offset(5)
        )

        #expect(Array(rotated) == ["b", "c", "d", "a"])
    }

    @Test
    func `large offset is normalized`() {
        let original = [1, 2, 3]
        let rotated = Collection.Rotated(
            base: original,
            startOffset: Index::Index<Int>.Offset(100)
        )

        #expect(Array(rotated) == [2, 3, 1])
    }

    @Test
    func `count matches base count`() {
        let original = [1, 2, 3, 4, 5]
        let rotated = Collection.Rotated(
            base: original,
            startOffset: Index::Index<Int>.Offset(2)
        )

        #expect(rotated.count == original.count)
    }

    @Test
    func `startIndex is zero`() {
        let rotated = Collection.Rotated(base: [1, 2, 3], startOffset: .one)

        #expect(rotated.startIndex == .zero)
    }

    @Test
    func `endIndex equals count`() {
        let rotated = Collection.Rotated(base: [1, 2, 3], startOffset: .one)
        let expected = Index::Index<Int>(_unchecked: Ordinal::Ordinal(3))

        #expect(rotated.endIndex == expected)
    }

    @Test
    func `subscript access at various positions`() {
        let original = ["a", "b", "c", "d", "e"]
        let rotated = Collection.Rotated(
            base: original,
            startOffset: Index::Index<String>.Offset(2)
        )

        let idx0: Index::Index<String> = .zero
        let one: Index::Index<String>.Count = .one

        #expect(rotated[idx0] == "c")
        #expect(rotated[idx0 + one] == "d")
        #expect(rotated[idx0 + count(2, for: String.self)] == "e")
        #expect(rotated[idx0 + count(3, for: String.self)] == "a")
        #expect(rotated[idx0 + count(4, for: String.self)] == "b")
    }

    @Test
    func `index arithmetic`() {
        let rotated = Collection.Rotated(base: [1, 2, 3, 4, 5], startOffset: .one)

        let idx0: Index::Index<Int> = .zero
        let idx1 = idx0 + count(1, for: Int.self)
        let idx2 = idx0 + count(2, for: Int.self)
        let idx3 = idx0 + count(3, for: Int.self)
        let idx4 = idx0 + count(4, for: Int.self)

        #expect(rotated.index(after: idx0) == idx1)
        #expect(rotated.index(before: idx3) == idx2)
        #expect(rotated.index(idx0, offsetBy: 3) == idx3)
        #expect(rotated.distance(from: idx1, to: idx4) == 3)
    }

    @Test
    func `reversed iteration`() {
        let original = [1, 2, 3, 4]
        let rotated = Collection.Rotated(base: original, startOffset: .one)

        #expect(Array(rotated.reversed()) == [1, 4, 3, 2])
    }
}

extension Collection.`Rotated Test`.`Edge Case` {

    @Test
    func `empty collection rotation`() {
        let empty: [Int] = []
        let rotated = Collection.Rotated(
            base: empty,
            startOffset: Index::Index<Int>.Offset(5)
        )

        #expect(rotated.isEmpty)
    }

    @Test
    func `single element rotation`() {
        let single = [42]
        let rotated = Collection.Rotated(base: single, startOffset: .one)

        #expect(Array(rotated) == [42])
    }
}

extension Collection.`Rotated Test`.Integration {

    @Test
    func `nested rotation`() {
        let original = [1, 2, 3, 4]
        let rotated1 = Collection.Rotated(base: original, startOffset: .one)
        let rotated2 = Collection.Rotated(base: rotated1, startOffset: .one)

        #expect(Array(rotated2) == [3, 4, 1, 2])
    }

    @Test
    func `works with ArraySlice`() {
        let array = [0, 1, 2, 3, 4, 5]
        let slice = array[1..<5]
        let rotated = Collection.Rotated(base: slice, startOffset: .one)

        #expect(Array(rotated) == [2, 3, 4, 1])
    }
}
