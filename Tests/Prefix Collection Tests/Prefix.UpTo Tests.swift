#if Prefix
import Collection
import Prefix
import Testing

@Suite
struct `Prefix.UpTo Tests` {
    @Test
    func `selection returns a slice without mutating its source`() throws {
        let input = "abc--def"
        let selection = Prefix.UpTo("--")
        #expect(try selection(input) == "abc")
        #expect(input == "abc--def")
    }

    @Test
    func `an unsatisfied selection throws its typed failure`() {
        let selection = Prefix.UpTo("--")
        #expect(throws: Prefix.UpTo<String>.Error.delimiterNotFound) { _ = try selection("abc-") }
    }
}

extension `Prefix.UpTo Tests` {
    @Test(arguments: ["", "abc"])
    func `an empty delimiter selects an empty prefix`(_ input: String) throws {
        #expect(try Prefix.UpTo("")(input).isEmpty)
        #expect(try Prefix.Through("")(input).isEmpty)
    }

    @Test
    func `overlapping candidates find the first full delimiter`() throws {
        #expect(try Prefix.UpTo("aab")("aaab-tail") == "a")
        #expect(try Prefix.Through("aab")("aaab-tail") == "aaab")
    }

    @Test
    func `selection works for nonzero based array slices`() throws {
        let input = [9, 1, 2, 3, 4][1...]
        #expect(try Prefix.UpTo([3, 4])(input) == [1, 2])
    }
}

#endif
