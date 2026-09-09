#if Prefix
import Collection
import Prefix
import Testing

@Suite
struct `Prefix.Through Tests` {
    @Test
    func `selection returns a slice without mutating its source`() throws {
        let input = "abc--def"
        let selection = Prefix.Through("--")
        #expect(try selection(input) == "abc--")
        #expect(input == "abc--def")
    }

    @Test
    func `an unsatisfied selection throws its typed failure`() {
        let selection = Prefix.Through("--")
        #expect(throws: Prefix.Through<String>.Error.delimiterNotFound) { _ = try selection("abc-") }
    }
}

#endif
