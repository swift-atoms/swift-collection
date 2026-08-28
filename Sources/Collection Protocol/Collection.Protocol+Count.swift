public import Cardinal
public import Index
public import Ordinal_Protocol
public import Sequence_Borrowing
public import Tagged

extension Collection.`Protocol` where Self: ~Copyable {

    @inlinable
    public var count: Index::Index<Element>.Count {
        borrowing get {
            var i = startIndex
            let end = endIndex
            var n = Cardinal(0)
            while i < end {
                n += Cardinal(1)
                i = index(after: i)
            }
            return Index::Index<Element>.Count(_unchecked: n)
        }
    }
}
