#if TaggedCollection
public import Index
internal import Ordinal
public import Tagged

extension Tagged
where
    Tag: ~Copyable & ~Escapable,
    Underlying: Collection.`Protocol`,
    Underlying.Element: Copyable,
    Underlying.Index == Index::Index<Underlying.Element>
{

    public var count: Index::Index<Tag>.Count {
        underlying.count.retag(Tag.self)
    }

    public var isEmpty: Bool {
        underlying.isEmpty
    }

    public var startIndex: Index::Index<Tag> {
        underlying.startIndex.retag(Tag.self)
    }

    public var endIndex: Index::Index<Tag> {
        underlying.endIndex.retag(Tag.self)
    }

    public func index(after i: Index::Index<Tag>) -> Index::Index<Tag> {
        underlying.index(after: i.retag(Underlying.Element.self)).retag(Tag.self)
    }

    public subscript(position: Index::Index<Tag>) -> Underlying.Element {
        underlying[position.retag(Underlying.Element.self)]
    }
}
#endif
