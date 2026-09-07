public import Affine
public import Cardinal
public import Index
public import Ordinal
public import Tagged

public struct __CollectionRotated<Base: RandomAccessCollection>: RandomAccessCollection {
    @usableFromInline
    let base: Base

    @usableFromInline
    let _offset: Index::Index<Base.Element>.Offset

    @usableFromInline
    let _count: Index::Index<Base.Element>.Count

    @inlinable
    public init(base: Base, startOffset: Index::Index<Base.Element>.Offset) {
        self.base = base
        let count = base.count
        self._count = Index::Index<Base.Element>.Count(_unchecked: Cardinal(UInt(count)))

        if base.isEmpty {
            self._offset = .zero
        } else {

            let remainder = startOffset.difference.magnitude.value.rawValue % UInt(count)
            let normalized = startOffset.difference.polarity == .negative && remainder != 0
                ? UInt(count) - remainder : remainder
            self._offset = Index::Index<Base.Element>.Offset(Int(normalized))
        }
    }
}

extension Collection.Rotated {

    public typealias Index = Index::Index<Base.Element>
}

extension Collection.Rotated {

    @inlinable
    public var startIndex: Index { .zero }

    @inlinable
    public var endIndex: Index { _count.map(Ordinal.init) }

    @inlinable
    public func index(after i: Index) -> Index {
        i.successor.saturating()
    }

    @inlinable
    public func index(before i: Index) -> Index {
        do throws(Ordinal.Error) {
            return try i.predecessor.exact()
        } catch {
            return .zero
        }
    }

    @inlinable

    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        do throws(Ordinal.Error) {
            return try i + Index.Offset(distance)
        } catch {
            return self.endIndex
        }
    }

    @inlinable

    public func distance(from start: Index, to end: Index) -> Int {
        try! (end - start).difference.intValue()
    }

    @inlinable
    public subscript(position: Index) -> Base.Element {

        let physicalIndex: Index
        do throws(Ordinal.Error) {
            physicalIndex = try (position + _offset) % _count
        } catch {
            physicalIndex = .zero
        }
        return base[
            base.index(base.startIndex, offsetBy: Int(bitPattern: physicalIndex.position.rawValue))
        ]
    }
}

extension Collection {

    public typealias Rotated<Base: RandomAccessCollection> = __CollectionRotated<Base>
}

extension Collection.Rotated: Swift.Sendable where Base: Swift.Sendable {}
