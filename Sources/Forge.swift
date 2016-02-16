import PathKit
import Yaml

public struct File {
  public let path: Path

  init(path: Path) {
    self.path = path
  }
}

public struct Lens<ObjectType, PropertyType> {
  let from: ObjectType -> PropertyType
  let to: (PropertyType, ObjectType) -> ObjectType
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
