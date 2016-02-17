import Foundation
import PathKit
import Yaml

public struct File {
  public let path: Path
  public let mode: Int
  public let contents: NSData
  public let frontmatter: [Yaml : Yaml]

  public init(path: Path, mode: Int, contents: NSData, frontmatter: [Yaml : Yaml]) {
    self.path = path
    self.mode = mode
    self.contents = contents
    self.frontmatter = frontmatter
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
  let parsesFrontmatter: Bool

  public init(container: Path = Path.current,
    source: Path = "site",
    destination: Path = "output",
    plugins: [Plugin] = [],
    ignores: [Path] = [],
    context: [Yaml : Yaml] = [:],
    parsesFrontmatter: Bool = true
  ) {
    self.container = container
    self.source = source
    self.destination = destination
    self.plugins = plugins
    self.ignores = ignores
    self.context = context
    self.parsesFrontmatter = parsesFrontmatter
  }

  func readFile(path: Path) -> File {
    return File(path: path, mode: 0o0000, contents: NSData(), frontmatter: [:])
  }

  func read() -> [File] {
    return source.glob("*")
      .lazy
      .filter(ignores.contains)
      .map { readFile($0) }
  }

  func build(clean clean: Bool = true) {
    let initial: PluginParameterType = (read(), self)

    let result = plugins.reduce(initial) { params, plugin in
      return plugin(params)
    }


    print(result)
  }
}

extension Forge {
  public func using(plugin: Plugin) -> Forge {
    let lens = ForgeLens.plugins
    return lens.to(lens.from(self) + [plugin], self)
  }

  public func ignoring(paths: [Path]) -> Forge {
    let lens = ForgeLens.ignores
    return lens.to(lens.from(self) + paths, self)
  }

  public func frontmatter(parseFrontmatter: Bool) -> Forge {
    let lens = ForgeLens.parsesFrontmatter
    return lens.to(parseFrontmatter, self)
  }
}
