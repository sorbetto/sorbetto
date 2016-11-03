import PathKit
import XCTest
@testable import Sorbetto

class SorbettoTests: XCTestCase {
    func makeTest(path: String) throws {
        let destination = try Path.uniqueTemporary()
        print(destination)

        let directoryPath = Path(#file) + "../../.." + path
        XCTAssertTrue(directoryPath.isDirectory)

        let site = Site(directory: directoryPath)
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
