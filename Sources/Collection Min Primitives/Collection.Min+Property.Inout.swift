public import Order_Primitives
internal import Property_Primitives

extension Property.Inout
where Base: Collection.`Protocol` & ~Copyable, Base.Index: Escapable, Tag == Collection.Min {

    @inlinable
    public func index(by comparator: Order.Comparator<Base.Element>) -> Base.Index? {
        var index = base.value.startIndex
        let endIndex = base.value.endIndex
        guard index < endIndex else { return nil }
        var bestIndex = index
        index = base.value.index(after: index)
        while index < endIndex {
            if comparator(base.value[index], base.value[bestIndex]) == .less {
                bestIndex = index
            }
            index = base.value.index(after: index)
        }
        return bestIndex
    }
}

extension Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Index: Escapable,
    Base.Element: Comparison.`Protocol` & SendableMetatype,
    Tag == Collection.Min
{

    @inlinable
    public func index() -> Base.Index? {
        index(by: .ascending)
    }
}

extension Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Index: Escapable,
    Base.Element: Copyable,
    Tag == Collection.Min
{

    @inlinable
    public func callAsFunction(by comparator: Order.Comparator<Base.Element>) -> Base.Element? {
        guard let idx = index(by: comparator) else { return nil }
        return base.value[idx]
    }
}

extension Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Index: Escapable,
    Base.Element: Copyable & Comparison.`Protocol` & SendableMetatype,
    Tag == Collection.Min
{

    @inlinable
    public func callAsFunction() -> Base.Element? {
        self(by: .ascending)
    }
}
