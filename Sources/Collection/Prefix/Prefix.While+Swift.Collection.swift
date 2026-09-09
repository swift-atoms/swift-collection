#if Prefix
public import Prefix
internal import Predicate

extension Prefix.While {
    public func end<C: Swift.Collection>(in input: C) throws(Prefix.Error) -> C.Index
    where C.Element == Element {
        try end(from: input.startIndex, advance: { position in
            position == input.endIndex ? nil : input.index(after: position)
        }, satisfies: { position, predicate in predicate(input[position]) })
    }

    public func callAsFunction<C: Swift.Collection>(_ input: C) throws(Prefix.Error) -> C.SubSequence
    where C.Element == Element {
        input[..<(try end(in: input))]
    }
}
#endif
