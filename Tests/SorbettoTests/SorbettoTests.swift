import PathKit
import XCTest
@testable import Sorbetto

class SorbettoTests: XCTestCase {
    func makeTest(path: String) throws {
        let destination = try Path.uniqueTemporary()
        print(destination)

        //
        // Why three ".."?
        //        <-(1) <-(2)         <-(3)
        // Sorbetto/Tests/SorbettoTests/X.swift
        //
        let fileToRoot = "../../.."

        let repoRoot = (Path(#file) + fileToRoot).normalize()
        let directoryPath = repoRoot + path
        XCTAssertTrue(directoryPath.isDirectory)

        let site = SiteBuilder(directory: directoryPath)
        site.destination = destination
        site.build { error, paths in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
    }

    func testFixture1() throws {
        try makeTest(path: "./Fixtures/Sites/01/")
    }

    static var allTests: [(String, (SorbettoTests) -> () throws -> Void)] {
        return [
            ("testFixture1", testFixture1),
        ]
    }
}