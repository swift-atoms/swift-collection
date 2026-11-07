public import Property

extension Collection.Slice {

    public protocol `Protocol`: Collection.`Protocol` & ~Copyable
    where Index: Swift::Comparable & Swift::Escapable {

        subscript(bounds: Range<Index>) -> Self { get }
    }
}

extension Collection.Slice.`Protocol` where Self: ~Copyable {

    @inlinable
    public var slice: Property::Property<Collection.Slice, Self>.Inout {
        mutating _read {
            yield Property::Property<Collection.Slice, Self>.Inout(&self)
        }
    }
}

extension Collection.Slice.`Protocol` where Self: ~Copyable {

    @inlinable
    public subscript(bounds: PartialRangeFrom<Index>) -> Self {
        _read {
            yield self[bounds.lowerBound..<endIndex]
        }
    }

    @inlinable
    public subscript(bounds: PartialRangeUpTo<Index>) -> Self {
        _read {
            yield self[startIndex..<bounds.upperBound]
        }
    }
}

extension Collection.Slice.`Protocol` {

    @inlinable
    public subscript(bounds: PartialRangeFrom<Index>) -> Self {
        self[bounds.lowerBound..<endIndex]
    }

    @inlinable
    public subscript(bounds: PartialRangeUpTo<Index>) -> Self {
        self[startIndex..<bounds.upperBound]
    }
}
