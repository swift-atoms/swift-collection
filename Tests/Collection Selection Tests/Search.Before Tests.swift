#if Search && Repetition
import Collection
import Search
import Repetition
import Cardinal
import Predicate
import Testing

@Suite
struct `Search.Before Tests` {
    @Test
    func `selection returns a slice without mutating its source`() throws {
        let input = "abc--def"
        let selection = Search("--").selecting(.start)
        #expect(try selection(input) == "abc")
        #expect(input == "abc--def")
    }

    @Test
    func `an unsatisfied selection throws its typed failure`() {
        let selection = Search("--").selecting(.start)
        #expect(throws: Search<String>.Error.notFound) { _ = try selection("abc-") }
    }
}

extension `Search.Before Tests` {
    @Test(arguments: ["", "abc"])
    func `an empty delimiter selects an empty prefix`(_ input: String) throws {
        #expect(try Search("").selecting(.start)(input).isEmpty)
        #expect(try Search("").selecting(.end)(input).isEmpty)
    }

    @Test
    func `overlapping candidates find the first full delimiter`() throws {
        #expect(try Search("aab").selecting(.start)("aaab-tail") == "a")
        #expect(try Search("aab").selecting(.end)("aaab-tail") == "aaab")
    }

    @Test
    func `selection works for nonzero based array slices`() throws {
        let input = [9, 1, 2, 3, 4][1...]
        #expect(try Search([3, 4]).selecting(.start)(input) == [1, 2])
    }
}

#endif
