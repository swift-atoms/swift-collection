public import Property_Primitives

extension Collection.Slice.`Protocol` where Self: ~Copyable {

    @inlinable
    public var slice: Property<Collection.Slice, Self>.Inout {
        mutating _read {
            yield Property<Collection.Slice, Self>.Inout(&self)
        }
    }
}
