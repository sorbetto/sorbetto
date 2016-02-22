import Foundation
import PathKit
import Yaml

public typealias PluginParameterType = ([Path : File], Sorbetto)
public typealias Plugin = (PluginParameterType) throws -> PluginParameterType


public struct Sorbetto {
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
}

public extension Sorbetto {
  func using(plugin: Plugin) -> Sorbetto {
    let lens = SorbettoLens.plugins
    return lens.to(lens.from(self) + [plugin], self)
  }

  func ignoring(paths: [Path]) -> Sorbetto {
    let lens = SorbettoLens.ignores
    return lens.to(lens.from(self) + paths, self)
  }

  func frontmatter(parseFrontmatter: Bool) -> Sorbetto {
    let lens = SorbettoLens.parsesFrontmatter
    return lens.to(parseFrontmatter, self)
  }

  func build(clean clean: Bool = true) throws -> Sorbetto {
    let initial: PluginParameterType = (try read(), self)
    let usingPlugins = defaultPlugins + plugins
    let (files, sorbetto) = try usingPlugins.reduce(initial) { params, plugin in try plugin(params) }
    try sorbetto.write(files)
    return sorbetto
  }
}

private extension Sorbetto {
  func read() throws -> [Path : File] {
    let ignores = self.ignores
    let absolutePath = (container + source).absolute()
    let paths = absolutePath
      .lazy
      .filter { !$0.isDirectory }
      .filter { !ignores.contains($0) }

    let sourceDepth = absolutePath.components.count
    var result = [Path : File]()
    for path in paths {
      let relativePath = Path(components: path.components.dropFirst(sourceDepth))
      result[relativePath] = try File.read(path)
    }

    return result
  }

  func write(files: [Path : File]) throws {
    for (path, file) in files {
      try file.write(container + destination + path)
    }
  }

  private var defaultPlugins: [Plugin] {
    var plugins = [Plugin]()

    if parsesFrontmatter {
      plugins.append(Frontmatter.application("---\n".dataUsingEncoding(NSUTF8StringEncoding)!))
    }

    return plugins
  }

}

