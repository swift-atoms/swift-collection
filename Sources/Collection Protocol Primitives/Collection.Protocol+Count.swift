public import Index_Primitives

extension Collection.`Protocol` where Self: ~Copyable {

    @inlinable
    public var count: Index_Primitives.Index<Element>.Count {
        borrowing get {
            var i = startIndex
            let end = endIndex
            var n = Cardinal.zero
            while i < end {
                n += .one
                i = index(after: i)
            }
            return Index_Primitives.Index<Element>.Count(_unchecked: n)
        }
    }
}
