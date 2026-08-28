import Property

extension Property.Inout
where Base: Collection.Slice.`Protocol` & ~Copyable, Tag == Collection.Slice {

}
