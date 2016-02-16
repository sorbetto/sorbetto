import PathKit
import Yaml

public struct File {
  public let path: Path

  init(path: Path) {
    self.path = path
  }
}

public struct Lens<ObjectType, PropertyType> {
  let get: ObjectType -> PropertyType
  let set: (PropertyType, ObjectType) -> ObjectType
}

public typealias PluginParameterType = ([File], Forge)
public typealias Plugin = PluginParameterType -> PluginParameterType

public struct Forge {
  public let container: Path
  public let source: Path
  public let destination: Path

  public let plugins: [Plugin]
  public let ignores: [Path]
  public let context: [Yaml : Yaml]
  public let shouldClean: Bool
  public let parsesFrontmatter: Bool

  public init(container: Path = Path.current,
    source: Path = "site",
    destination: Path = "output",
    plugins: [Plugin] = [],
    ignores: [Path] = [],
    context: [Yaml : Yaml] = [:],
    shouldClean: Bool = true,
    parsesFrontmatter: Bool = true
    ) {
    self.container = container
    self.source = source
    self.destination = destination
    self.plugins = plugins
    self.ignores = ignores
    self.context = context
    self.shouldClean = shouldClean
    self.parsesFrontmatter = parsesFrontmatter
  }
}

extension Forge {
  public func use(plugin: Plugin) -> Forge {
    let lens = Forge.pluginsLens
    return lens.set(lens.get(self) + [plugin], self)
  }

  public func ignore(paths: [Path]) -> Forge {
    let lens = Forge.ignoresLens
    return lens.set(lens.get(self) + paths, self)
  }

  public func clean(shouldClean: Bool) -> Forge {
    let lens = Forge.shouldCleanLens
    return lens.set(shouldClean, self) 
  }

  public func frontmatter(parseFrontmatter: Bool) -> Forge {
    let lens = Forge.parsesFrontmatterLens
    return lens.set(parseFrontmatter, self)
  }
}

extension Forge {
  public static let containerLens = Lens<Forge, Path>(get: { $0.container }, set: { container, forge -> Forge in
    return Forge(container: container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 shouldClean: forge.shouldClean,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let sourceLens = Lens<Forge, Path>(get: { $0.source }, set: { source, forge -> Forge in
    return Forge(container: forge.container,
                 source: source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 shouldClean: forge.shouldClean,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let destinationLens = Lens<Forge, Path>(get: { $0.destination }, set: { destination, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 shouldClean: forge.shouldClean,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let pluginsLens = Lens<Forge, [Plugin]>(get: { $0.plugins }, set: { plugins, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 shouldClean: forge.shouldClean,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let ignoresLens = Lens<Forge, [Path]>(get: { $0.ignores }, set: { ignores, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: ignores,
                 context: forge.context,
                 shouldClean: forge.shouldClean,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let contextLens = Lens<Forge, [Yaml : Yaml]>(get: { $0.context }, set: { context, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: context,
                 shouldClean: forge.shouldClean,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let shouldCleanLens = Lens<Forge, Bool>(get: { $0.shouldClean }, set: { shouldClean, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 shouldClean: shouldClean,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let parsesFrontmatterLens = Lens<Forge, Bool>(get: { $0.parsesFrontmatter }, set: { parsesFrontmatter, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 shouldClean: forge.shouldClean,
                 parsesFrontmatter: parsesFrontmatter)
  })
}
