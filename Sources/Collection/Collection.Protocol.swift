public import Comparison
public import Index
public import Iterable

extension Collection {

    public protocol `Protocol`: Iterable, ~Copyable
    where
        Element: ~Copyable,
        Iterator.Element == Element,
        Iterator.Failure == Never
    {
        associatedtype Element: ~Copyable

        associatedtype Index: Comparison.`Protocol` & ~Escapable = Index.Index<Element>

        var startIndex: Index { get }

        var endIndex: Index { get }

        subscript(_ position: Index) -> Element { get }

        @_lifetime(copy i)
        func index(after i: Index) -> Index
    }
}
