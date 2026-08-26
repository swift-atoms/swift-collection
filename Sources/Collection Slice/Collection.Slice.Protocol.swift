extension Collection.Slice {

    public protocol `Protocol`: Collection.`Protocol` & ~Copyable
    where Index: Swift.Comparable & Swift.Escapable {

        subscript(bounds: Range<Index>) -> Self { get }
    }
}
