import Foundation
import PathKit

public typealias BuildCompletionHandler = (_ error: Error?, _ site: Site) -> Void
public typealias IgnoreFilter = (Path) -> Bool

public struct SiteBuilder {
    var absoluteSource: Path

    var absoluteDestination: Path

    public var directory: Path {
        didSet {
            assert(directory.isAbsolute)
            absoluteSource = source.absolutePath(relativeTo: directory)
            absoluteDestination = destination.absolutePath(relativeTo: directory)
        }
    }

    public var source: Path {
        didSet {
            absoluteSource = source.absolutePath(relativeTo: directory)
        }
    }

    public var destination: Path {
        didSet {
            absoluteDestination = destination.absolutePath(relativeTo: directory)
        }
    }

    public var plugins = [Plugin]()

    public var metadata = Metadata()

    public var parsesFrontmatter = true

    public var shouldCleanBeforeBuild = true

    public var ignoreFilters = [IgnoreFilter]()

    public init(directory: Path = Path.current, source: Path = "./src", destination: Path = "./build") {
        self.directory = directory

        self.source = source
        self.absoluteSource = source.absolutePath(relativeTo: directory)

        self.destination = destination
        self.absoluteDestination = destination.absolutePath(relativeTo: directory)
    }

    public mutating func use(_ plugin: Plugin) {
        plugins.append(plugin)
    }

    public func process(completionHandler: @escaping BuildCompletionHandler) {
        var plugins = self.plugins
        if parsesFrontmatter {
            plugins.insert(FrontmatterParser(), at: 0)
        }

        let site = Site(source: absoluteSource, paths: loadPaths())
        site.run(plugins: plugins, completionHandler: completionHandler)
    }

    public func build(completionHandler: @escaping BuildCompletionHandler) {
        process { previousError, site in
            guard previousError == nil else {
                completionHandler(previousError, site)
                return
            }

            do {
                try self.cleanIfNeeded()

                for path in site.paths {
                    try self.write(path: path, file: site.memoizedFiles[path])
                }

                completionHandler(nil, site)
            } catch {
                completionHandler(error, site)
            }
        }
    }

    public mutating func ignore(_ path: Path) {
        let relativePath: Path
        if path.isAbsolute {
            relativePath = path.relativePath(from: absoluteSource)
        } else {
            relativePath = path
        }

        ignoreFilters.append { $0 == relativePath }
    }

    public mutating func ignore(pattern: String) {
        let paths = absoluteSource.glob(pattern)
        ignoreFilters.append { path in paths.contains(path) }
    }

    public mutating func ignore(_ filter: @escaping IgnoreFilter) {
        ignoreFilters.append(filter)
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

    func loadPaths() -> Set<Path> {
        do {
            let children = try absoluteSource.recursiveChildren()
                .filter { path in !shouldIgnore(path) }
                .map { path in path.relativePath(from: absoluteSource) }
            return Set(children)
        } catch {
            return []
        }
    }

    func write(path: Path, file: File?) throws {
        let destinationPath = path.absolutePath(relativeTo: absoluteDestination)

        let destinationParent = destinationPath.parent()
        if !destinationParent.exists {
            try destinationParent.mkpath()
        }

        if let data = file?.contentsIfLoaded {
            try destinationPath.write(data)
        } else {
            let sourcePath = path.absolutePath(relativeTo: absoluteSource)
            try sourcePath.copy(destinationPath)
        }
    }

    func cleanIfNeeded() throws {
        if shouldCleanBeforeBuild {
            try absoluteDestination.delete()
        }
    }
}
