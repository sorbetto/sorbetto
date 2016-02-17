import Foundation
import PathKit
import Yaml

public typealias PluginParameterType = ([Path : File], Forge)
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

  func readFile(path: Path) throws -> File {
    let contents: NSData = try path.read()
    return File(contents: contents, context: [:])
  }

  func read() throws -> [Path : File] {
    let sourceDepth = source.components.count
    let ignores = self.ignores
    let paths = try source.recursiveChildren()
      .lazy
      .filter { !$0.isDirectory }
      .filter { !ignores.contains($0) }

    var result = [Path : File]()
    for path in paths {
      let relativePath = Path(components: path.components.dropFirst(sourceDepth))
      result[relativePath] = try readFile(path)
    }

    return result
  }

  func writeFile(file: File, toPath path: Path) throws {
    if !path.parent().exists {
      try path.parent().mkpath()
    }

    try path.write(file.contents)
  }

  func write(files: [Path : File]) throws {
    for (path, file) in files {
      try writeFile(file, toPath: destination + path)
    }
  }

  func build(clean clean: Bool = true) throws -> [Path : File] {
    let initial: PluginParameterType = (try read(), self)
    let (files, forge) = plugins.reduce(initial) { params, plugin in plugin(params) }
    try forge.write(files)
    return files
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
