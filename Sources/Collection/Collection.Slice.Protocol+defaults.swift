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
