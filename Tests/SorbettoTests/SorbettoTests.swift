import PathKit
import XCTest
import Yaml
@testable import Sorbetto

class SorbettoTests: XCTestCase {
    @discardableResult
    func buildTest(path: String) throws -> Site {
        let destination = try Path.uniqueTemporary()

        //
        // Why three ".."?
        //        <-(1) <-(2)         <-(3)
        // Sorbetto/Tests/SorbettoTests/X.swift
        //
        let fileToRoot = "../../.."

        let repoRoot = (Path(#file) + fileToRoot).normalize()
        let directoryPath = repoRoot + path
        XCTAssertTrue(directoryPath.isDirectory)

        return try Sorbetto(directory: directoryPath, destination: destination)
            .build()
    }

    func testFixture1() throws {
        try buildTest(path: "./Fixtures/Sites/01/")
    }

    func testFixture2() throws {
        let site = try buildTest(path: "./Fixtures/Sites/02/")

        guard let index = site["index.md"] else {
            XCTFail("index.md should exist")
            return
        }

        guard case .dictionary(let dict)? = index.metadata.frontmatter else {
            XCTFail("Frontmatter should have been parsed as dictionary")
            return
        }

        XCTAssertEqual(dict["title"], "An Example")
        XCTAssertEqual(dict["date"], "2001-01-01")
        XCTAssertEqual(dict["draft"], false)
    }

    static var allTests: [(String, (SorbettoTests) -> () throws -> Void)] {
        return [
            ("testFixture1", testFixture1),
            ("testFixture2", testFixture2),
        ]
    }
}
