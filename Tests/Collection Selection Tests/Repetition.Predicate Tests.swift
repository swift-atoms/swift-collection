#if Search && Repetition
import Collection
import Search
import Repetition
import Cardinal
import Predicate
import Testing

@Suite
struct `Repetition.Predicate Tests` {
    @Test
    func `selection returns a slice without mutating its source`() throws {
        let input = "abc--def"
        let selection = Repetition((Cardinal(UInt(1))...), operation: Predicate<Character>{ $0 != "-" })
        #expect(try selection(input) == "abc")
        #expect(input == "abc--def")
    }

    @Test
    func `an unsatisfied selection throws its typed failure`() {
        let selection = Repetition((Cardinal(UInt(1))...), operation: Predicate<Character>{ $0 != "-" })
        #expect(throws: Repetition<PartialRangeFrom<Cardinal>, Void>.Error.insufficient(actual: 0)) { _ = try selection("--") }
    }
}

#endif
