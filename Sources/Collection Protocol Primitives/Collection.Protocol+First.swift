extension Collection.`Protocol` where Self: ~Copyable, Element: Copyable {

    @inlinable
    public var first: Element? {
        isEmpty ? nil : self[startIndex]
    }
}
