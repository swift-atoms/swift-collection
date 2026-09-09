#if Prefix
public import Prefix

extension Prefix.Through where Delimiter: Swift.Collection, Delimiter.Element: Equatable {
    public func end<C: Swift.Collection>(in input: C) throws(Prefix.Through<Delimiter>.Error) -> C.Index
    where C.Element == Delimiter.Element {
        try end(from: input.startIndex, advance: { position in
            position == input.endIndex ? nil : input.index(after: position)
        }, matching: { delimiter, position in
            var end = position
            for element in delimiter {
                guard end != input.endIndex, input[end] == element else { return nil }
                input.formIndex(after: &end)
            }
            return end
        })
    }

    public func callAsFunction<C: Swift.Collection>(_ input: C) throws(Prefix.Through<Delimiter>.Error) -> C.SubSequence
    where C.Element == Delimiter.Element {
        input[..<(try end(in: input))]
    }
}
#endif
