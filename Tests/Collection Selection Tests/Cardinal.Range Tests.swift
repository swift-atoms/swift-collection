#if Search && Repetition
import Collection
import Search
import Repetition
import Cardinal
import Predicate
import Testing

@Suite
struct `Prefix Tests` {
    @Test
    func `selection returns a slice without mutating its source`() throws {
        let input = "abc--def"
        let selection = (Cardinal(UInt(2))...Cardinal(UInt(2)))
        #expect(try selection(input) == "ab")
        #expect(input == "abc--def")
    }

    @Test
    func `an unsatisfied selection throws its typed failure`() {
        let selection = (Cardinal(UInt(2))...Cardinal(UInt(2)))
        #expect(throws: Repetition<ClosedRange<Cardinal>, Void>.Error.insufficient(actual: 1)) { _ = try selection("a") }
    }
}

#endif
