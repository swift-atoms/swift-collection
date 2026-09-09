#if Prefix
public import Prefix

extension Prefix {
    public func end<C: Swift.Collection>(in input: C) throws(Prefix.Error) -> C.Index {
        try end(from: input.startIndex) { position in
            position == input.endIndex ? nil : input.index(after: position)
        }
    }

    public func callAsFunction<C: Swift.Collection>(_ input: C) throws(Prefix.Error) -> C.SubSequence {
        input[..<(try end(in: input))]
    }
}
#endif
