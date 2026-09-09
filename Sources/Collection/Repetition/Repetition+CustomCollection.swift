#if Repetition
public import Repetition
public import Cardinal
public import Predicate

extension Repetition where Bounds: Cardinal.Range {
    public func end<C: Collection.`Protocol` & ~Copyable>(
        inCollection input: borrowing C
    ) throws(Repetition<Bounds, Void>.Error) -> C.Index where Operation == Predicate<C.Element>, C.Element: ~Copyable, C.Index: Escapable {
        try bounds.end(from: input.startIndex) { position in
            guard position != input.endIndex, operation(input[position]) else { return nil }
            return input.index(after: position)
        }
    }
}
#endif
