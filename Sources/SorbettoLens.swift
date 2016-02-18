import PathKit
import Yaml

public struct SorbettoLens {
  public static let container = Lens<Sorbetto, Path>(from: { $0.container }, to: { container, sorbetto -> Sorbetto in
    return Sorbetto(container: container,
                 source: sorbetto.source,
                 destination: sorbetto.destination,
                 plugins: sorbetto.plugins,
                 ignores: sorbetto.ignores,
                 context: sorbetto.context,
                 parsesFrontmatter: sorbetto.parsesFrontmatter)
  })

  public static let source = Lens<Sorbetto, Path>(from: { $0.source }, to: { source, sorbetto -> Sorbetto in
    return Sorbetto(container: sorbetto.container,
                 source: source,
                 destination: sorbetto.destination,
                 plugins: sorbetto.plugins,
                 ignores: sorbetto.ignores,
                 context: sorbetto.context,
                 parsesFrontmatter: sorbetto.parsesFrontmatter)
  })

  public static let destination = Lens<Sorbetto, Path>(from: { $0.destination }, to: { destination, sorbetto -> Sorbetto in
    return Sorbetto(container: sorbetto.container,
                 source: sorbetto.source,
                 destination: destination,
                 plugins: sorbetto.plugins,
                 ignores: sorbetto.ignores,
                 context: sorbetto.context,
                 parsesFrontmatter: sorbetto.parsesFrontmatter)
  })

  public static let plugins = Lens<Sorbetto, [Plugin]>(from: { $0.plugins }, to: { plugins, sorbetto -> Sorbetto in
    return Sorbetto(container: sorbetto.container,
                 source: sorbetto.source,
                 destination: sorbetto.destination,
                 plugins: plugins,
                 ignores: sorbetto.ignores,
                 context: sorbetto.context,
                 parsesFrontmatter: sorbetto.parsesFrontmatter)
  })

  public static let ignores = Lens<Sorbetto, [Path]>(from: { $0.ignores }, to: { ignores, sorbetto -> Sorbetto in
    return Sorbetto(container: sorbetto.container,
                 source: sorbetto.source,
                 destination: sorbetto.destination,
                 plugins: sorbetto.plugins,
                 ignores: ignores,
                 context: sorbetto.context,
                 parsesFrontmatter: sorbetto.parsesFrontmatter)
  })

  public static let context = Lens<Sorbetto, [Yaml : Yaml]>(from: { $0.context }, to: { context, sorbetto -> Sorbetto in
    return Sorbetto(container: sorbetto.container,
                 source: sorbetto.source,
                 destination: sorbetto.destination,
                 plugins: sorbetto.plugins,
                 ignores: sorbetto.ignores,
                 context: context,
                 parsesFrontmatter: sorbetto.parsesFrontmatter)
  })

  public static let parsesFrontmatter = Lens<Sorbetto, Bool>(from: { $0.parsesFrontmatter }, to: { parsesFrontmatter, sorbetto -> Sorbetto in
    return Sorbetto(container: sorbetto.container,
                 source: sorbetto.source,
                 destination: sorbetto.destination,
                 plugins: sorbetto.plugins,
                 ignores: sorbetto.ignores,
                 context: sorbetto.context,
                 parsesFrontmatter: parsesFrontmatter)
  })
}
