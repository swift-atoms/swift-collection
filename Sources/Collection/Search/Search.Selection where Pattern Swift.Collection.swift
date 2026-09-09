#if Search
public import Search

extension Search.Selection where Pattern: Swift.Collection, Pattern.Element: Equatable {
    public func end<C: Swift.Collection>(in input: C) throws(Search<Pattern>.Error) -> C.Index
    where C.Element == Pattern.Element {
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

    public func callAsFunction<C: Swift.Collection>(_ input: C) throws(Search<Pattern>.Error) -> C.SubSequence
    where C.Element == Pattern.Element {
        input[..<(try end(in: input))]
    }
}
#endif
