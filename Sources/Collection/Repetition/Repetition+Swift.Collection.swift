#if Repetition
public import Repetition
public import Cardinal
public import Predicate

extension Repetition where Bounds: Cardinal.Range {
    public func end<C: Swift.Collection>(
        in input: C
    ) throws(Repetition<Bounds, Void>.Error) -> C.Index where Operation == Predicate<C.Element> {
        try bounds.end(from: input.startIndex) { position in
            guard position != input.endIndex, operation(input[position]) else { return nil }
            return input.index(after: position)
        }
    }
    public func callAsFunction<C: Swift.Collection>(_ input: C) throws(Repetition<Bounds, Void>.Error) -> C.SubSequence
    where Operation == Predicate<C.Element> { input[..<(try end(in: input))] }
}
#endif
