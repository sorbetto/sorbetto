import Foundation
import PathKit
import Yaml

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
    let mode = path.fileMode ?? 0o0000
    let contents = (try? path.read()) ?? NSData()
    return File(path: path, mode: mode, contents: contents, frontmatter: [:])
  }

  func read() -> [File] {
    let ignores = self.ignores
    return source.glob("**/*")
      .lazy
      .filter { !ignores.contains($0) }
      .map(readFile)
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
