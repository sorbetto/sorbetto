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

  private static let frontmatterTag = "---\n".dataUsingEncoding(NSUTF8StringEncoding)!

  func readFrontmatter(data: NSData) -> (NSData, [Yaml : Yaml])? {
    // data.length > 8 must be true for "---\n---\n"
    guard data.length > 2 * Sorbetto.frontmatterTag.length &&
      data.subdataWithRange(NSRange(0..<Sorbetto.frontmatterTag.length)) == Sorbetto.frontmatterTag
    else { return nil }

    let endRange = data.rangeOfData(Sorbetto.frontmatterTag,
      options: [],
      range: NSRange(Sorbetto.frontmatterTag.length..<data.length))
    guard endRange.length > 0 else { return nil }

    let yamlData = data.subdataWithRange(NSRange(0..<endRange.location))

    var string: NSString?
    let encoding = NSString.stringEncodingForData(yamlData, encodingOptions: nil, convertedString: &string, usedLossyConversion: nil)
    if encoding != 0, let string = string, frontmatter = Yaml.load(string as String).value?.dictionary {
      let contents = data.subdataWithRange(NSRange(NSMaxRange(endRange)..<data.length))
      return (contents, frontmatter)
    } else {
      return nil
    }
  }

  func readFile(path: Path) throws -> File {
    let data: NSData = try path.read()
    if let (contents, context) = readFrontmatter(data) {
      return File(contents: contents, context: context)
    } else {
      return File(contents: data, context: [:])
    }
  }

  func read() throws -> [Path : File] {
    let ignores = self.ignores
    let paths = try source.recursiveChildren()
      .lazy
      .filter { !$0.isDirectory }
      .filter { !ignores.contains($0) }

    let sourceDepth = source.components.count
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

  public func build(clean clean: Bool = true) throws -> [Path : File] {
    let initial: PluginParameterType = (try read(), self)
    let (files, sorbetto) = try plugins.reduce(initial) { params, plugin in try plugin(params) }
    try sorbetto.write(files)
    return files
  }
}

extension Sorbetto {
  public func using(plugin: Plugin) -> Sorbetto {
    let lens = SorbettoLens.plugins
    return lens.to(lens.from(self) + [plugin], self)
  }

  public func ignoring(paths: [Path]) -> Sorbetto {
    let lens = SorbettoLens.ignores
    return lens.to(lens.from(self) + paths, self)
  }

  public func frontmatter(parseFrontmatter: Bool) -> Sorbetto {
    let lens = SorbettoLens.parsesFrontmatter
    return lens.to(parseFrontmatter, self)
  }
}
