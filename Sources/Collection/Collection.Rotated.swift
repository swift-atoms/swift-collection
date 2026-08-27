public struct __CollectionRotated<Base: RandomAccessCollection>: RandomAccessCollection {
    @usableFromInline
    let base: Base

    @usableFromInline
    let _offset: Int

    @usableFromInline
    let _count: Int

    @inlinable
    public init(base: Base, startOffset: Int) {
        self.base = base
        let count = base.count
        self._count = count

        if base.isEmpty {
            self._offset = 0
        } else {
            self._offset = ((startOffset % count) + count) % count
        }
    }
}

extension Collection.Rotated {

    public typealias Index = Int
}

extension Collection.Rotated {

    @inlinable
    public var startIndex: Index { 0 }

    @inlinable
    public var endIndex: Index { _count }

    @inlinable
    public func index(after i: Index) -> Index {
        i + 1
    }

    @inlinable
    public func index(before i: Index) -> Index {
        i - 1
    }

    @inlinable

    public func index(_ i: Index, offsetBy distance: Int) -> Index {
        i + distance
    }

    @inlinable

    public func distance(from start: Index, to end: Index) -> Int {
        end - start
    }

    @inlinable
    public subscript(position: Index) -> Base.Element {
        let physicalIndex = (position + _offset) % _count
        return base[base.index(base.startIndex, offsetBy: physicalIndex)]
    }
}

extension Collection.Rotated: Sendable where Base: Sendable {}

extension Collection {

    public typealias Rotated<Base: RandomAccessCollection> = __CollectionRotated<Base>
}
