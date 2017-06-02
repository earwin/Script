import Quick
import Nimble
@testable import Script

class BufferTests: QuickSpec {
  override func spec() {
    it("defaults to not finished") {
      expect(Buffer().isFinish()).to(beFalse())
    }

    it("defaults to empty") {
      expect(Buffer().toString()).to(beEmpty())
    }

    it("contains data") {
      let buffer = Buffer()
      buffer.append(string: "ABC")
      expect(buffer.toString()).to(equal("ABC"))
    }

    it("resets store") {
      let buffer = Buffer(withDelimiter: "NOT FOUND")
      buffer.append(string: "ABC")
      expect(buffer.reset()).to(beEmpty())
      expect(buffer.toString()).to(equal("ABC"))
    }

    context("isFinish") {
      it("is not after appending ") {
        let buffer = Buffer(withDelimiter: "DEF")
        buffer.append(string: "ABC")
        expect(buffer.isFinish()).to(beFalse())
      }

      it("finds in the end") {
        let buffer = Buffer(withDelimiter: "DEF")
        buffer.append(string: "DEF")
        expect(buffer.isFinish()).to(beTrue())
        expect(buffer.reset()).to(equal([""]))
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.toString()).to(beEmpty())
      }

      it("finds near the end") {
        let buffer = Buffer(withDelimiter: "DEF")
        buffer.append(string: "DEFXXX")
        expect(buffer.isFinish()).to(beTrue())
        expect(buffer.reset()).to(equal([""]))
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.toString()).to(equal("XXX"))
      }
    }

    context("edge cases") {
      it("handles longer delimiter then current buffer length (empty)") {
        let buffer = Buffer(withDelimiter: "ABC")
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.reset()).to(beEmpty())
        expect(buffer.toString()).to(beEmpty())
      }

       it("handles longer delimiter then current buffer length") {
        let buffer = Buffer(withDelimiter: "ABC")
        buffer.append(string: "X")
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.reset()).to(beEmpty())
        expect(buffer.toString()).to(equal("X"))
      }

      it("shorter delimiter then buffer content") {
        let buffer = Buffer(withDelimiter: "A")
        buffer.append(string: "BC")
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.reset()).to(beEmpty())
        expect(buffer.toString()).to(equal("BC"))
      }

      it("handles partial matched delimiter") {
        let buffer = Buffer(withDelimiter: "AB")
        buffer.append(string: "A")
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.reset()).to(beEmpty())
        expect(buffer.toString()).to(equal("A"))
      }

      it("handles empty delimiter") {
        let buffer = Buffer(withDelimiter: "")
        buffer.append(string: "ABC")
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.reset()).to(beEmpty())
        expect(buffer.toString()).to(equal("ABC"))
      }

      it("handles empty delimiter and buffer") {
        let buffer = Buffer(withDelimiter: "")
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.reset()).to(beEmpty())
        expect(buffer.toString()).to(beEmpty())
      }
    }

    context("multiply results") {
      it("is not after appending") {
        let buffer = Buffer(withDelimiter: "DEF")
        buffer.append(string: "ABC")
        buffer.append(string: "ABC")
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.toString()).to(equal("ABCABC"))
      }

      it("finds in the end") {
        let buffer = Buffer(withDelimiter: "DEF")
        buffer.append(string: "DEF")
        buffer.append(string: "X")
        buffer.append(string: "DEF")
        expect(buffer.isFinish()).to(beTrue())
        let res = buffer.reset()
        expect(res).to(equal(["", "X"]))
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.toString()).to(beEmpty())
      }

      it("finds near the end") {
        let buffer = Buffer(withDelimiter: "DEF")
        buffer.append(string: "DEFXXX")
        buffer.append(string: "DEFXXX")
        expect(buffer.isFinish()).to(beTrue())
        expect(buffer.reset()).to(equal(["", "XXX"]))
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.toString()).to(equal("XXX"))
      }

      it("finds delimiters in a row") {
        let buffer = Buffer(withDelimiter: "X")
        buffer.append(string: "XXX")
        expect(buffer.isFinish()).to(beTrue())
        expect(buffer.reset()).to(equal(["", "", ""]))
        expect(buffer.isFinish()).to(beFalse())
        expect(buffer.toString()).to(beEmpty())
      }

      it("handles recurring rows") {
        let buffer = Buffer(withDelimiter: "X")
        buffer.append(string: "XA")
        expect(buffer.isFinish()).to(beTrue())
        expect(buffer.reset()).to(equal([""]))
        buffer.append(string: "X")
        expect(buffer.isFinish()).to(beTrue())
        expect(buffer.reset()).to(equal(["A"]))
      }
    }
  }
}
