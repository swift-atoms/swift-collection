#if Prefix
import Collection
import Prefix
import Testing

@Suite
struct `Prefix.While Tests` {
    @Test
    func `selection returns a slice without mutating its source`() throws {
        let input = "abc--def"
        let selection = Prefix.While<Character>(minimum: 1) { $0 != "-" }
        #expect(try selection(input) == "abc")
        #expect(input == "abc--def")
    }

    @Test
    func `an unsatisfied selection throws its typed failure`() {
        let selection = Prefix.While<Character>(minimum: 1) { $0 != "-" }
        #expect(throws: Prefix.Error.insufficientElements(minimum: 1, actual: 0)) { _ = try selection("--") }
    }
}

#endif
