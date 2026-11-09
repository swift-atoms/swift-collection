public import Cardinal
public import Index
public import Ordinal
public import Sequence
public import Tagged

extension Collection {

    public protocol `Protocol`: Sequence.Borrowing.`Protocol`, ~Copyable
    where
        Element: ~Copyable,
        Iterator.Element == Element,
        Iterator.Failure == Never
    {
        associatedtype Index: Swift::Comparable & ~Escapable =
            Index::Index<Element>

        var startIndex: Index { get }

        var endIndex: Index { get }

        subscript(_ position: Index) -> Element { get }

        var count: Index::Index<Element>.Count { borrowing get }

        func index(after i: Index) -> Index
    }
}

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

extension Collection.`Protocol` where Self: ~Copyable {

    @inlinable
    public var isEmpty: Bool { startIndex == endIndex }

    @inlinable

    public func formIndex(after i: inout Index) {
        i = index(after: i)
    }
}
