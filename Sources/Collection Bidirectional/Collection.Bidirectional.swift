extension Collection {

    public protocol Bidirectional: Collection.`Protocol` & ~Copyable {

        @_lifetime(copy i)
        func index(before i: Index) -> Index
    }
}
