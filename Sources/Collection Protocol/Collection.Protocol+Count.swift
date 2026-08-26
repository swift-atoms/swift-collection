public import Index

extension Collection.`Protocol` where Self: ~Copyable {

    @inlinable
    public var count: Index.Index<Element>.Count {
        borrowing get {
            var i = startIndex
            let end = endIndex
            var n = Cardinal.zero
            while i < end {
                n += .one
                i = index(after: i)
            }
            return Index.Index<Element>.Count(_unchecked: n)
        }
    }
}
