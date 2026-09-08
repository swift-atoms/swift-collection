import Cardinal
import Index
import Ordinal
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
    struct `Rotated collections preserve indexed elements under normalized offsets` {
        @Suite struct `Rotated collection indices and elements follow the normalized offset` {}
        @Suite struct `Rotation preserves empty singleton and extreme offset behavior` {}
        @Suite struct `Rotation composes across nested collections and slices` {}
    }
}

extension Collection.`Rotated collections preserve indexed elements under normalized offsets`.`Rotated collection indices and elements follow the normalized offset` {

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
    func `Rotated subscripts follow the normalized element order`() {
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
    func `Rotated index arithmetic preserves offsets and distances`() {
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
    func `Reversed traversal reverses the rotated element order`() {
        let original = [1, 2, 3, 4]
        let rotated = Collection.Rotated(base: original, startOffset: .one)

        #expect(Array(rotated.reversed()) == [1, 4, 3, 2])
    }
}

extension Collection.`Rotated collections preserve indexed elements under normalized offsets`.`Rotation preserves empty singleton and extreme offset behavior` {

    @Test
    func `Rotating an empty collection preserves emptiness`() {
        let empty: [Int] = []
        let rotated = Collection.Rotated(
            base: empty,
            startOffset: Index::Index<Int>.Offset(5)
        )

        #expect(rotated.isEmpty)
    }

    @Test
    func `Rotating a single element preserves that element`() {
        let single = [42]
        let rotated = Collection.Rotated(base: single, startOffset: .one)

        #expect(Array(rotated) == [42])
    }
}

extension Collection.`Rotated collections preserve indexed elements under normalized offsets`.`Rotation composes across nested collections and slices` {

    @Test
    func `Nested rotations compose their offsets`() {
        let original = [1, 2, 3, 4]
        let rotated1 = Collection.Rotated(base: original, startOffset: .one)
        let rotated2 = Collection.Rotated(base: rotated1, startOffset: .one)

        #expect(Array(rotated2) == [3, 4, 1, 2])
    }

    @Test
    func `Rotation preserves the elements of an array slice`() {
        let array = [0, 1, 2, 3, 4, 5]
        let slice = array[1..<5]
        let rotated = Collection.Rotated(base: slice, startOffset: .one)

        #expect(Array(rotated) == [2, 3, 4, 1])
    }
}

extension Collection.`Rotated collections preserve indexed elements under normalized offsets`.`Rotation preserves empty singleton and extreme offset behavior` {
    @Test(arguments: [-1, -4, Int.min, Int.max])
    func `signed offsets normalize without integer overflow`(_ offset: Int) {
        let rotated = Collection.Rotated(base: [0, 1, 2], startOffset: .init(offset))
        let remainder = offset % 3
        let normalized = remainder < 0 ? remainder + 3 : remainder
        #expect(Array(rotated) == (0..<3).map { ($0 + normalized) % 3 })
        #expect(rotated.distance(from: rotated.endIndex, to: rotated.startIndex) == -3)
    }
}
