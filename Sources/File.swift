import Foundation
import PathKit

public class File {
    fileprivate let sourcePath: Path?
    public var metadata: [MetadataKey: Any]

    public var contentsIfLoaded: Data?
    public var contents: Data {
        get {
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

    init(sourcePath: Path) {
        assert(sourcePath.isAbsolute)
        self.sourcePath = sourcePath
        self.metadata = [:]
    }

    public init(contents: Data, metadata: [MetadataKey: Any] = [:]) {
        self.sourcePath = nil
        self.metadata = metadata
        self.contentsIfLoaded = contents
    }
}
