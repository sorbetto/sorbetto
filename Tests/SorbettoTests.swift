import Spectre
import PathKit
@testable import Sorbetto

func testSorbetto() {
  describe("Sorbetto") {
    $0.context("Lenses") {
      let sorbetto = Sorbetto()

      $0.context("Container") {
        $0.it("should return the container") {
          let lens = SorbettoLens.container

          let container = lens.from(sorbetto)

          try expect(container) == sorbetto.container
        }

        $0.it("should update the container and preserve other state") {
          let lens = SorbettoLens.container

          let newContainer: Path = "./somedir"

          let newSorbetto = lens.to(newContainer, sorbetto)

          // Verify Write
          try expect(newSorbetto.container) == newContainer

          // Verify no state changes
          try expect(newSorbetto.source) == sorbetto.source
          try expect(newSorbetto.destination) == sorbetto.destination
          try expect(newSorbetto.plugins.count) == sorbetto.plugins.count
          try expect(newSorbetto.ignores.count) == sorbetto.ignores.count
          try expect(newSorbetto.parsesFrontmatter) == sorbetto.parsesFrontmatter
        }
      }

      $0.context("Source") {
        $0.it("should return the source") {
          let lens = SorbettoLens.source

          let source = lens.from(sorbetto)

          try expect(source) == sorbetto.source
        }

        $0.it("should update the source and preserve other state") {
          let lens = SorbettoLens.source

          let newSource: Path = "./somedir"

          let newSorbetto = lens.to(newSource, sorbetto)

          // Verify Write
          try expect(newSorbetto.source) == newSource

          // Verify no state changes
          try expect(newSorbetto.container) == sorbetto.container
          try expect(newSorbetto.destination) == sorbetto.destination
          try expect(newSorbetto.plugins.count) == sorbetto.plugins.count
          try expect(newSorbetto.ignores.count) == sorbetto.ignores.count
          try expect(newSorbetto.parsesFrontmatter) == sorbetto.parsesFrontmatter
        }
      }

      $0.context("Destination") {
        $0.it("should return the destination") {
          let lens = SorbettoLens.destination

          let destination = lens.from(sorbetto)

          try expect(destination) == sorbetto.destination
        }

        $0.it("should update the destination and preserve other state") {
          let lens = SorbettoLens.source

          let newSource: Path = "./somedir"

          let newSorbetto = lens.to(newSource, sorbetto)

          // Verify Write
          try expect(newSorbetto.source) == newSource

          // Verify no state changes
          try expect(newSorbetto.container) == sorbetto.container
          try expect(newSorbetto.destination) == sorbetto.destination
          try expect(newSorbetto.plugins.count) == sorbetto.plugins.count
          try expect(newSorbetto.ignores.count) == sorbetto.ignores.count
          try expect(newSorbetto.parsesFrontmatter) == sorbetto.parsesFrontmatter
        }
      }
    }
  }
}
