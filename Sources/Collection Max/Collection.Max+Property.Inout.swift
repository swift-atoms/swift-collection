public import Comparison_Protocol
public import Order_Comparator
public import Property_Inout

extension Property::Property.Inout
where Base: Collection.`Protocol` & ~Copyable, Base.Index: Escapable, Tag == Collection.Max {

    @inlinable
    public func index(by comparator: Order::Order.Comparator<Base.Element>) -> Base.Index? {
        var index = base.value.startIndex
        let endIndex = base.value.endIndex
        guard index < endIndex else { return nil }
        var bestIndex = index
        index = base.value.index(after: index)
        while index < endIndex {
            if comparator(base.value[index], base.value[bestIndex]) == .greater {
                bestIndex = index
            }
            index = base.value.index(after: index)
        }
        return bestIndex
    }
}

extension Property::Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Index: Escapable,
    Base.Element: Comparison::Comparison.`Protocol` & SendableMetatype,
    Tag == Collection.Max
{

    @inlinable
    public func index() -> Base.Index? {
        index(by: .ascending)
    }
}

extension Property::Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Index: Escapable,
    Base.Element: Copyable,
    Tag == Collection.Max
{

    @inlinable
    public func callAsFunction(
        by comparator: Order::Order.Comparator<Base.Element>
    ) -> Base.Element? {
        guard let idx = index(by: comparator) else { return nil }
        return base.value[idx]
    }
}

extension Property::Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Index: Escapable,
    Base.Element: Copyable & Comparison::Comparison.`Protocol` & SendableMetatype,
    Tag == Collection.Max
{

    @inlinable
    public func callAsFunction() -> Base.Element? {
        self(by: .ascending)
    }
}
