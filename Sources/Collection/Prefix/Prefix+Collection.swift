#if Prefix
public import Prefix
internal import Predicate

extension Prefix {
    /// Selects a boundary in the ecosystem collection contract without copying
    /// the collection or its elements. Uses equality and forward indexing only.
    public func end<C: Collection.`Protocol` & ~Copyable>(
        inCollection input: borrowing C
    ) throws(Error) -> C.Index where C.Index: Escapable {
        var end = input.startIndex
        var count = 0
        while end != input.endIndex && count < maximum {
            end = input.index(after: end)
            count += 1
        }
        guard count >= minimum else { throw .insufficientElements(minimum: minimum, actual: count) }
        return end
    }
}

extension Prefix.While where Element: ~Copyable & Escapable {
    public func end<C: Collection.`Protocol` & ~Copyable>(
        inCollection input: borrowing C
    ) throws(Prefix.Error) -> C.Index where C.Element == Element, C.Element: ~Copyable, C.Index: Escapable {
        var end = input.startIndex
        var count = 0
        while end != input.endIndex && count < bounds.maximum && predicate(input[end]) {
            end = input.index(after: end)
            count += 1
        }
        guard count >= bounds.minimum else {
            throw .insufficientElements(minimum: bounds.minimum, actual: count)
        }
        return end
    }
}

extension Prefix.UpTo {
    public func end<C: Collection.`Protocol` & ~Copyable>(
        inCollection input: borrowing C
    ) throws(Error) -> C.Index where C.Element == Delimiter.Element, C.Index: Comparable & Escapable {
        try match(inCollection: input).lowerBound
    }

    func match<C: Collection.`Protocol` & ~Copyable>(
        inCollection input: borrowing C
    ) throws(Error) -> Range<C.Index> where C.Element == Delimiter.Element, C.Index: Comparable & Escapable {
        var start = input.startIndex
        while true {
            var end = start
            var matched = true
            for element in delimiter {
                guard end != input.endIndex, input[end] == element else {
                    matched = false
                    break
                }
                end = input.index(after: end)
            }
            if matched { return start..<end }
            guard start != input.endIndex else { throw .delimiterNotFound }
            start = input.index(after: start)
        }
    }
}

extension Prefix.Through {
    public func end<C: Collection.`Protocol` & ~Copyable>(
        inCollection input: borrowing C
    ) throws(Error) -> C.Index where C.Element == Delimiter.Element, C.Index: Comparable & Escapable {
        try Prefix.UpTo(delimiter).match(inCollection: input).upperBound
    }
}

#endif
