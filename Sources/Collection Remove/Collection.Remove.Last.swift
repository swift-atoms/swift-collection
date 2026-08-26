extension Collection.Remove.Last where Self: ~Copyable {

    public var remove: Collection.Remove.View<Self> {
        mutating _read {
            yield unsafe Collection.Remove.View(&self)
        }
        mutating _modify {
            var view = unsafe Collection.Remove.View(&self)
            yield &view
        }
    }
}

extension Collection.Remove {

    public protocol Last: Collection.`Protocol` & ~Copyable {

        static func removeLast(_ base: inout Self) -> Element?
    }
}
