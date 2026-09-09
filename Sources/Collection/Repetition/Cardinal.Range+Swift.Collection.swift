#if Repetition
public import Repetition
public import Cardinal

extension Cardinal.Range {
    public func end<C: Swift.Collection>(in input: C) throws(Repetition<Self, Void>.Error) -> C.Index {
        try end(from: input.startIndex) { position in
            position == input.endIndex ? nil : input.index(after: position)
        }
    }

    public func callAsFunction<C: Swift.Collection>(_ input: C) throws(Repetition<Self, Void>.Error) -> C.SubSequence {
        input[..<(try end(in: input))]
    }
}
#endif
