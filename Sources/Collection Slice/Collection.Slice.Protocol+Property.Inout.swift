public import Property_Inout

extension Collection.Slice.`Protocol` where Self: ~Copyable {

    @inlinable
    public var slice: Property::Property<Collection.Slice, Self>.Inout {
        mutating _read {
            yield Property::Property<Collection.Slice, Self>.Inout(&self)
        }
    }
}
