public import Sequence_Borrowing

extension Collection.Remove {

    @safe
    public struct View<Base: Collection.Remove.Last & ~Copyable>: ~Copyable, ~Escapable {
        @usableFromInline
        internal let _base: UnsafeMutablePointer<Base>

        @inlinable
        @_lifetime(borrow base)
        public init(_ base: UnsafeMutablePointer<Base>) {
            unsafe _base = base
        }
    }
}

extension Collection.Remove.View where Base: ~Copyable {

    @inlinable
    public mutating func last() -> Base.Element? {
        unsafe Base.removeLast(&_base.pointee)
    }
}
