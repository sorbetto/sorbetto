import Spectre
import PathKit
@testable import Forge

func testForge() {
  describe("Forge") {
    $0.context("Lenses") {
      let forge = Forge()

      $0.context("Container") {
        $0.it("should return the container") {
          let lens = ForgeLens.container

          let container = lens.from(forge)

          try expect(container) == forge.container
        }

        $0.it("should update the container and preserve other state") {
          let lens = ForgeLens.container

          let newContainer: Path = "./somedir"

          let newForge = lens.to(newContainer, forge)

          // Verify Write
          try expect(newForge.container) == newContainer

          // Verify no state changes
          try expect(newForge.source) == forge.source
          try expect(newForge.destination) == forge.destination
          try expect(newForge.plugins.count) == forge.plugins.count
          try expect(newForge.ignores.count) == forge.ignores.count
          try expect(newForge.shouldClean) == forge.shouldClean
          try expect(newForge.parsesFrontmatter) == forge.parsesFrontmatter
        }
      }

      $0.context("Source") {
        $0.it("should return the source") {
          let lens = ForgeLens.source

          let source = lens.from(forge)

          try expect(source) == forge.source
        }

        $0.it("should update the source and preserve other state") {
          let lens = ForgeLens.source

          let newSource: Path = "./somedir"

          let newForge = lens.to(newSource, forge)

          // Verify Write
          try expect(newForge.source) == newSource

          // Verify no state changes
          try expect(newForge.container) == forge.container
          try expect(newForge.destination) == forge.destination
          try expect(newForge.plugins.count) == forge.plugins.count
          try expect(newForge.ignores.count) == forge.ignores.count
          try expect(newForge.shouldClean) == forge.shouldClean
          try expect(newForge.parsesFrontmatter) == forge.parsesFrontmatter
        }
      }

      $0.context("Destination") {
        $0.it("should return the destination") {
          let lens = ForgeLens.destination

          let destination = lens.from(forge)

          try expect(destination) == forge.destination
        }

        $0.it("should update the destination and preserve other state") {
          let lens = ForgeLens.source

          let newSource: Path = "./somedir"

          let newForge = lens.to(newSource, forge)

          // Verify Write
          try expect(newForge.source) == newSource

          // Verify no state changes
          try expect(newForge.container) == forge.container
          try expect(newForge.destination) == forge.destination
          try expect(newForge.plugins.count) == forge.plugins.count
          try expect(newForge.ignores.count) == forge.ignores.count
          try expect(newForge.shouldClean) == forge.shouldClean
          try expect(newForge.parsesFrontmatter) == forge.parsesFrontmatter
        }
      }
    }
  }
}
