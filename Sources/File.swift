import Foundation
import PathKit

public struct File {
    let sourcePath: Path?
    public var metadata = [AnyHashable: Any]()

    public var contentsIfLoaded: Data?
    public var contents: Data {
        mutating get {
            let contents: Data
            if let _contents = contentsIfLoaded {
                contents = _contents
            } else if let sourcePath = self.sourcePath, let data = try? sourcePath.read() {
                contentsIfLoaded = data
                contents = data
            } else {
                let data = Data()
                contentsIfLoaded = data
                contents = data
            }

            return contents
        }
        set {
            contentsIfLoaded = newValue
        }
    }

    init(sourcePath: Path? = nil, metadata: [AnyHashable: Any] = [:]) {
        if let sourcePath = sourcePath {
            assert(sourcePath.isAbsolute)
        }

        self.sourcePath = sourcePath
    }

    public init(metadata: [AnyHashable: Any] = [:]) {
        self.init(sourcePath: nil, metadata: metadata)
    }
}
