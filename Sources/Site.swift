import PathKit

public class Site {
    var memoizedFiles = [Path: File]()

    public let source: Path
    public var paths: Set<Path>

    public subscript(_ string: String) -> File? {
        get {
            return self[Path(string)]
        }
        set {
            self[Path(string)] = newValue
        }
    }

    public subscript(_ path: Path) -> File? {
        get {
            assert(path.isRelative)

            if let file = memoizedFiles[path] {
                return file
            } else if paths.contains(path) {
                let sourcePath = path.absolute(relativeTo: source)
                let file = File(sourcePath: sourcePath)
                memoizedFiles[path] = file
                return file
            } else {
                return nil
            }
        }
        set {
            assert(path.isRelative)

            if let newValue = newValue {
                paths.insert(path)
                memoizedFiles[path] = newValue
            } else {
                paths.remove(path)
                memoizedFiles[path] = nil
            }
        }
    }

    public init(source: Path, paths: Set<Path>) {
        assert(source.isAbsolute)
        self.source = source
        self.paths = paths
    }

    public func run(plugins: [Plugin]) throws {
        for plugin in plugins {
            try plugin.run(site: self)
        }
    }
}
