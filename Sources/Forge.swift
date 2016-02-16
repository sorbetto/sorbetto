import PathKit
import Yaml

public struct File {
  public let path: Path

  public init(path: Path) {
    self.path = path
  }
}

public struct Lens<ObjectType, PropertyType> {
  public let from: (ObjectType) -> PropertyType
  public let to: (PropertyType, ObjectType) -> ObjectType

  public init(from: (ObjectType) -> PropertyType, to: (PropertyType, ObjectType) -> ObjectType) {
    self.from = from
    self.to = to
  }
}

public typealias PluginParameterType = ([File], Forge)
public typealias Plugin = (PluginParameterType) -> PluginParameterType

public struct Forge {
  let container: Path
  let source: Path
  let destination: Path

  let plugins: [Plugin]
  let ignores: [Path]
  let context: [Yaml : Yaml]
  let shouldClean: Bool
  let parsesFrontmatter: Bool

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
    let lens = ForgeLens.plugins
    return lens.to(lens.from(self) + [plugin], self)
  }

  public func ignore(paths: [Path]) -> Forge {
    let lens = ForgeLens.ignores
    return lens.to(lens.from(self) + paths, self)
  }

  public func clean(shouldClean: Bool) -> Forge {
    let lens = ForgeLens.shouldClean
    return lens.to(shouldClean, self)
  }

  public func frontmatter(parseFrontmatter: Bool) -> Forge {
    let lens = ForgeLens.parsesFrontmatter
    return lens.to(parseFrontmatter, self)
  }
}
