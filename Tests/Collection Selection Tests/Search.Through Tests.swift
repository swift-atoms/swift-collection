#if Search && Repetition
import Collection
import Search
import Repetition
import Cardinal
import Predicate
import Testing

@Suite
struct `Search.Through Tests` {
    @Test
    func `selection returns a slice without mutating its source`() throws {
        let input = "abc--def"
        let selection = Search("--").selecting(.end)
        #expect(try selection(input) == "abc--")
        #expect(input == "abc--def")
    }

    @Test
    func `an unsatisfied selection throws its typed failure`() {
        let selection = Search("--").selecting(.end)
        #expect(throws: Search<String>.Error.notFound) { _ = try selection("abc-") }
    }
}

#endif
