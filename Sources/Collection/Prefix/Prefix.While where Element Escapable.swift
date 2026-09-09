#if Prefix
public import Prefix
internal import Predicate

extension Prefix.While where Element: ~Copyable & Escapable {
    public func end<C: Collection.`Protocol` & ~Copyable>(
        inCollection input: borrowing C
    ) throws(Prefix.Error) -> C.Index where C.Element == Element, C.Element: ~Copyable, C.Index: Escapable {
        try end(from: input.startIndex, advance: { position in
            position == input.endIndex ? nil : input.index(after: position)
        }, satisfies: { position, predicate in predicate(input[position]) })
    }
}
#endif
