#if Prefix
import Collection
import Prefix
import Testing

@Suite
struct `Prefix Tests` {
    @Test
    func `selection returns a slice without mutating its source`() throws {
        let input = "abc--def"
        let selection = Prefix(minimum: 2, maximum: 2)
        #expect(try selection(input) == "ab")
        #expect(input == "abc--def")
    }

    @Test
    func `an unsatisfied selection throws its typed failure`() {
        let selection = Prefix(minimum: 2, maximum: 2)
        #expect(throws: Prefix.Error.insufficientElements(minimum: 2, actual: 1)) { _ = try selection("a") }
    }
}

#endif
