#if Prefix
public import Prefix

extension Prefix.UpTo where Delimiter: Swift.Collection, Delimiter.Element: Equatable {
    public func end<C: Collection.`Protocol` & ~Copyable>(
        inCollection input: borrowing C
    ) throws(Prefix.UpTo<Delimiter>.Error) -> C.Index where C.Element == Delimiter.Element, C.Index: Escapable {
        try end(from: input.startIndex, advance: { position in
            position == input.endIndex ? nil : input.index(after: position)
        }, matching: { delimiter, position in
            var end = position
            for element in delimiter {
                guard end != input.endIndex, input[end] == element else { return nil }
                end = input.index(after: end)
            }
            return end
        })
    }
}
#endif
