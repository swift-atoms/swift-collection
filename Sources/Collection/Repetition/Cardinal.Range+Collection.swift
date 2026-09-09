#if Repetition
public import Repetition
public import Cardinal

extension Cardinal.Range {
    public func end<C: Collection.`Protocol` & ~Copyable>(
        inCollection input: borrowing C
    ) throws(Repetition<Self, Void>.Error) -> C.Index where C.Index: Escapable {
        try end(from: input.startIndex) { position in
            position == input.endIndex ? nil : input.index(after: position)
        }
    }
}
#endif
