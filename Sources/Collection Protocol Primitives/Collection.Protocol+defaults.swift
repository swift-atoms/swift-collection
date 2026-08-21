extension Collection.`Protocol` where Self: ~Copyable {

    @inlinable
    public var isEmpty: Bool { startIndex == endIndex }

    @inlinable

    public func formIndex(after i: inout Index) {
        i = index(after: i)
    }
}
