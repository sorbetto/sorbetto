import Spectre
import Foundation
import Yaml
@testable import Sorbetto

extension String {
  var UTF8Data: NSData? {
    return dataUsingEncoding(NSUTF8StringEncoding)
  }
}

func testFrontmatter() {
  describe("Frontmatter") {
    $0.context("when initialized with String data") {
      $0.context("that has frontmatter") {
        let sut = Frontmatter(data: "---\ntitle: Introducing Sorbetto\n---\nThis is some content.".UTF8Data!, tag: "---\n".UTF8Data!)
        
        $0.it("should correctly calculate the end tag range") {
          let range = sut.rangeOfTerminatingFrontmatterTag

          try expect(range?.location) == 32
          try expect(range?.length) == 4
        }

        $0.it("should correctly retreive values") {
          let result = sut.result
          let title = result.1["title"]?.string

          try expect(title) == "Introducing Sorbetto"
        }

        $0.it("should not include the frontmatter in contents") {
          let body = sut.result.0
          let bodyText = String(data: body, encoding: NSUTF8StringEncoding)

          try expect(bodyText) == "This is some content."
        }
      }

      $0.context("that has frontmatter tags but no content") {
        let sut = Frontmatter(data: "---\n---\n".UTF8Data!, tag: "---\n".UTF8Data!)
        
        $0.it("should have an empty yaml") {
          let keys = sut.result.1.keys

          try expect(keys.count) == 0
        }

        $0.it("should have empty contents") {
          let body = sut.result.0
          let string = String(data: body, encoding: NSUTF8StringEncoding)
          try expect(string) == ""
        }
      }

      $0.context("that is shorter than the tag length") {
        let sut = Frontmatter(data: "---\nHi".UTF8Data!, tag: "---\n".UTF8Data!)

        $0.it("should have an empty yaml section") {
          let keys = sut.result.1.keys

          try expect(keys.count) == 0
        }

        $0.it("should have valid contents") {
          let body = sut.result.0

          try expect(body) == "---\nHi".UTF8Data!
        }
      }

      $0.context("that has a nonterminating frontmatter block") {
        $0.it("should have an empty yaml section") {}

        $0.it("should have valid contents") {}
      }
    }
  }
}
