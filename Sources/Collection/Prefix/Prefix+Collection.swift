#if Prefix
public import Prefix

extension Prefix {
    public func end<C: Collection.`Protocol` & ~Copyable>(
        inCollection input: borrowing C
    ) throws(Prefix.Error) -> C.Index where C.Index: Escapable {
        try end(from: input.startIndex) { position in
            position == input.endIndex ? nil : input.index(after: position)
        }
    }
}
#endif
