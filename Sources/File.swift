import Foundation
import PathKit

public class File {
    fileprivate let sourcePath: Path?
    public var metadata: Metadata

    public var contentsIfLoaded: Data?
    public var contents: Data {
        get {
            if let contents = contentsIfLoaded {
                return contents
            } else if let sourcePath = self.sourcePath, let data = try? sourcePath.read() {
                contentsIfLoaded = data
                return data
            } else {
                let data = Data()
                contentsIfLoaded = data
                return data
            }
        }
        set {
            contentsIfLoaded = newValue
        }
    }

    init(sourcePath: Path) {
        assert(sourcePath.isAbsolute)
        self.sourcePath = sourcePath
        self.metadata = Metadata()
    }

    public init(contents: Data, metadata: Metadata = Metadata()) {
        self.sourcePath = nil
        self.metadata = metadata
        self.contentsIfLoaded = contents
    }
}
