public import Comparison_Protocol
public import Index
public import Sequence_Borrowing

extension Collection {

    public protocol `Protocol`: Sequence.Borrowing.`Protocol`, ~Copyable
    where
        Element: ~Copyable,
        Iterator.Element == Element,
        Iterator.Failure == Never
    {
        associatedtype Index: Comparison::Comparison.`Protocol` & ~Escapable =
            Index::Index<Element>

        var startIndex: Index { get }

        var endIndex: Index { get }

        subscript(_ position: Index) -> Element { get }

        func index(after i: Index) -> Index
    }
}
