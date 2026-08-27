extension Collection.`Protocol` where Self: ~Copyable {

    @inlinable
    public var count: Int {
        borrowing get {
            var i = startIndex
            let end = endIndex
            var n = 0
            while i < end {
                n += 1
                i = index(after: i)
            }
            return n
        }
    }
}
