import Spectre
import PathKit
@testable import Forge

func testForge() {
  describe("Forge") {
    $0.context("Lenses") {
      let forge = Forge()

      $0.context("Container") {
        $0.it("should return the container") {
          let lens = Forge.containerLens

          let container = lens.get(forge)

          try expect(container) == forge.container
        }

        $0.it("should update the container and preserve other state") {
          let lens = Forge.containerLens

          let newContainer: Path = "./somedir"
          
          let newForge = lens.set(newContainer, forge)

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
          let lens = Forge.sourceLens

          let source = lens.get(forge)

          try expect(source) == forge.source
        }

        $0.it("should update the source and preserve other state") {
          let lens = Forge.sourceLens

          let newSource: Path = "./somedir"
          
          let newForge = lens.set(newSource, forge)

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
          let lens = Forge.destinationLens

          let destination = lens.get(forge)

          try expect(destination) == forge.destination
        }

        $0.it("should update the destination and preserve other state") {
          let lens = Forge.sourceLens

          let newSource: Path = "./somedir"
          
          let newForge = lens.set(newSource, forge)

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
