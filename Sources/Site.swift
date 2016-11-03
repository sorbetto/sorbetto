import Foundation
import PathKit

public typealias PathFilter = (Path) -> Bool

public typealias BuildCompletionHandler = (_ error: Error?, _ paths: Set<Path>) -> Void

public class Site {
    public var directory: Path
    public var source: Path = "./src"
    public var destination: Path = "./build"
    var plugins = [Plugin]()
    public var metadata = [AnyHashable: Any]()
    // public var parsesFrontmatter = true
    // public var shouldCleanBeforeBuild = true
    var ignoreFilters = [PathFilter]()
    var memoizedFiles = [Path: File]()
    public lazy var allPaths: Set<Path> = self.loadPaths()

    public init(directory: Path) {
        self.directory = directory
    }

    public func use(_ plugin: Plugin) {
        plugins.append(plugin)
    }

    public func process(completionHandler: @escaping BuildCompletionHandler) {
        run(plugins: plugins, completionHandler: completionHandler)
    }

    public func build(completionHandler: @escaping BuildCompletionHandler) {
        process { previousError, paths in
            guard previousError == nil else {
                completionHandler(previousError, paths)
                return
            }

            do {
                let absoluteSource = self.resolve(self.source, against: self.directory)
                let absoluteDestination = self.resolve(self.destination, against: self.directory)

                var newPaths = Set<Path>()
                for path in paths {
                    let absoluteAgainstDestination = self.resolve(path, against: absoluteDestination)

                    let parent = absoluteAgainstDestination.parent()
                    if !parent.exists {
                        try parent.mkpath()
                    }
                    
                    if let file = self.memoizedFiles[path], let data = file.contentsIfLoaded {
                        try absoluteAgainstDestination.write(data)
                    } else {
                        let absoluteAgainstSource = self.resolve(path, against: absoluteSource)
                        try absoluteAgainstSource.copy(absoluteAgainstDestination)
                    }

                    newPaths.insert(absoluteAgainstDestination)
                }

                completionHandler(nil, newPaths)
            } catch {
                completionHandler(error, paths)
            }
        }
    }

    public func ignore(_ path: Path) {
        let path = resolve(path, against: source)
        ignoreFilters.append { $0 == path }
    }

    public func ignore(pattern: String) {
        let paths = directory.glob(pattern)
        ignoreFilters.append { path in paths.contains(path) }
    }

    public func ignore(_ filter: @escaping PathFilter) {
        ignoreFilters.append(filter)
    }

    public subscript(_ string: String) -> File {
        get {
            return self[Path(string)]
        }
        set {
            self[Path(string)] = newValue
        }
    }

    public subscript(_ path: Path) -> File {
        get {
            let path = resolve(path, against: source)
            if let memoizedFile = memoizedFiles[path] {
                return memoizedFile
            }

            let file = File(sourcePath: path, metadata: [:])
            memoizedFiles[path] = file
            return file
        }
        set {
            let path = resolve(path, against: source)
            memoizedFiles[path] = newValue
        }
    }

    func resolve(_ path: Path, against directory: Path) -> Path {
        if path.isRelative {
            return directory + path
        } else {
            return path
        }
    }

    func shouldIgnore(_ path: Path) -> Bool {
        if path.isDirectory {
            // TODO: Ignore empty directories?
            return true
        }

        for shouldIgnore in ignoreFilters {
            if shouldIgnore(path) {
                return true
            }
        }

        return false
    }

    func relativize(_ path: Path, against directory: Path) -> Path {
        assert(directory.isAbsolute)
        guard path.isAbsolute else {
            return path
        }

        let components = path.components
        let index: Int = {
            let directoryComponents = directory.components
            for (i, (c1, c2)) in zip(components, directoryComponents).enumerated() {
                if c1 != c2 {
                    return i
                }
            }

            return min(directoryComponents.count, components.count)
        }()

        return Path(components: components[index ..< components.endIndex])
    }

    func loadPaths() -> Set<Path> {
        do {
            let absoluteSource = resolve(source, against: directory)
            let children = try absoluteSource.recursiveChildren()
                .filter { path in !shouldIgnore(path) }
                .map { path in relativize(path, against: absoluteSource) }
            return Set(children)
        } catch {
            return []
        }
    }

    func run(plugins: [Plugin], completionHandler: @escaping BuildCompletionHandler) {
        guard !plugins.isEmpty else {
            completionHandler(nil, allPaths)
            return
        }

        var nextPlugins = plugins

        let plugin = nextPlugins.removeFirst()
        plugin.run(site: self) { error in
            if let error = error {
                completionHandler(error, self.allPaths)
            } else {
                run(plugins: nextPlugins, completionHandler: completionHandler)
            }
        }
    }

    func write(file: File, to path: Path) throws {
        let path = resolve(relativize(path, against: source), against: destination)
        if let contents = file.contentsIfLoaded {
            try path.write(contents)
        } else if let sourcePath = file.sourcePath {
            try sourcePath.copy(path)
        } else {
            assertionFailure()
        }
    }
}
