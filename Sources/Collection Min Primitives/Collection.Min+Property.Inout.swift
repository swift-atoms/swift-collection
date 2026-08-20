public import Order_Primitives
internal import Property_Primitives

// MARK: - Universal index-based min (works with ~Copyable elements)

// NOTE: The index-returning APIs require `Base.Index: Escapable` — they return a
// *stored* index, which a `~Escapable` index cannot be. Conformers with the
// default `Index<Element>` (Escapable) are unaffected; custom `~Escapable`-index
// types simply don't get min-by-index. (Collection.`Protocol`.Index is a
// `~Escapable`-admitting associatedtype since the index-suppression change.)

/// Property.Inout extensions for finding minimum element index on `Collection.Protocol` conformers.
extension Property.Inout
where Base: Collection.`Protocol` & ~Copyable, Base.Index: Escapable, Tag == Collection.Min {

    /// Find index of minimum element using comparator via `.min.index(by:)`.
    ///
    /// Returns the index of the minimum element according to the comparator,
    /// or `nil` if the collection is empty. Works with `~Copyable` elements.
    ///
    /// ```swift
    /// var container = MyContainer([3, 1, 4, 1, 5])
    /// if let idx = container.min.index(by: .ascending) {
    ///     print(container[idx])  // 1
    /// }
    /// ```
    ///
    /// - Parameter comparator: The comparator defining the ordering.
    /// - Returns: The index of the minimum element, or `nil` if empty.
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

/// Convenience `min.index()` for `Comparison.Protocol` elements.
extension Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Index: Escapable,
    Base.Element: Comparison.`Protocol` & SendableMetatype,
    Tag == Collection.Min
{

    /// Find index of minimum element using natural ordering via `.min.index()`.
    ///
    /// - Returns: The index of the minimum element, or `nil` if empty.
    @inlinable
    public func index() -> Base.Index? {
        index(by: .ascending)
    }
}

// MARK: - Copyable element min value (returns Element via index + subscript)

/// Property.Inout extensions for finding minimum element on collections with Copyable elements.
extension Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Index: Escapable,
    Base.Element: Copyable,
    Tag == Collection.Min
{

    /// Find minimum element using comparator via `.min(by:)`.
    ///
    /// Returns the minimum element according to the comparator, or `nil` if empty.
    /// Requires `Element: Copyable` to return the element by value.
    ///
    /// ```swift
    /// var container = MyContainer([3, 1, 4, 1, 5])
    /// container.min(by: .ascending)  // Optional(1)
    /// container.min(by: .descending) // Optional(5)
    /// ```
    ///
    /// - Parameter comparator: The comparator defining the ordering.
    /// - Returns: The minimum element, or `nil` if the collection is empty.
    @inlinable
    public func callAsFunction(by comparator: Order.Comparator<Base.Element>) -> Base.Element? {
        guard let idx = index(by: comparator) else { return nil }
        return base.value[idx]
    }
}

/// Property.Inout extensions for finding minimum element on collections with Comparison.Protocol elements.
extension Property.Inout
where
    Base: Collection.`Protocol` & ~Copyable,
    Base.Index: Escapable,
    Base.Element: Copyable & Comparison.`Protocol` & SendableMetatype,
    Tag == Collection.Min
{

    /// Find minimum element using natural ordering via `.min()`.
    ///
    /// Returns the minimum element according to natural ascending order, or `nil` if empty.
    ///
    /// ```swift
    /// var numbers = MyContainer([3, 1, 4, 1, 5])
    /// numbers.min()  // Optional(1)
    /// ```
    ///
    /// - Returns: The minimum element, or `nil` if the collection is empty.
    @inlinable
    public func callAsFunction() -> Base.Element? {
        self(by: .ascending)
    }
}
