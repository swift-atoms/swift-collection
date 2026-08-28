public import Index

public struct __CollectionRotated<Base: RandomAccessCollection>: RandomAccessCollection {
    @usableFromInline
    let base: Base

    @usableFromInline
    let _offset: Index.Index<Base.Element>.Offset

    @usableFromInline
    let _count: Index.Index<Base.Element>.Count

    @inlinable
    public init(base: Base, startOffset: Index.Index<Base.Element>.Offset) {
        self.base = base
        let count = base.count
        self._count = Index.Index<Base.Element>.Count(_unchecked: Cardinal(UInt(count)))

        if base.isEmpty {
            self._offset = .zero
        } else {

            let offsetValue = Int(bitPattern: startOffset)
            let normalizedValue = ((offsetValue % count) + count) % count
            self._offset = Index.Index<Base.Element>.Offset(normalizedValue)
        }
    }
}

extension Collection.Rotated {

    public typealias Index = Index.Index<Base.Element>
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
        do throws(Affine.Discrete.Vector.Error) {
            return Int(bitPattern: try end - start as Affine.Discrete.Vector)
        } catch {
            return .zero
        }
    }

    @inlinable
    public subscript(position: Index) -> Base.Element {

        let physicalIndex: Index
        do throws(Ordinal.Error) {
            physicalIndex = try (position + _offset) % _count
        } catch {
            physicalIndex = .zero
        }
        return base[base.index(base.startIndex, offsetBy: Int(bitPattern: physicalIndex.position))]
    }
}

extension Collection.Rotated: Sendable where Base: Sendable {}

extension Collection {

    public typealias Rotated<Base: RandomAccessCollection> = __CollectionRotated<Base>
}
