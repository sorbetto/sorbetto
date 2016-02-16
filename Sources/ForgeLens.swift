import PathKit
import Yaml

public struct ForgeLens {
  public static let container = Lens<Forge, Path>(from: { $0.container }, to: { container, forge -> Forge in
    return Forge(container: container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let source = Lens<Forge, Path>(from: { $0.source }, to: { source, forge -> Forge in
    return Forge(container: forge.container,
                 source: source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let destination = Lens<Forge, Path>(from: { $0.destination }, to: { destination, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let plugins = Lens<Forge, [Plugin]>(from: { $0.plugins }, to: { plugins, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let ignores = Lens<Forge, [Path]>(from: { $0.ignores }, to: { ignores, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: ignores,
                 context: forge.context,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let context = Lens<Forge, [Yaml : Yaml]>(from: { $0.context }, to: { context, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: context,
                 parsesFrontmatter: forge.parsesFrontmatter)
  })

  public static let parsesFrontmatter = Lens<Forge, Bool>(from: { $0.parsesFrontmatter }, to: { parsesFrontmatter, forge -> Forge in
    return Forge(container: forge.container,
                 source: forge.source,
                 destination: forge.destination,
                 plugins: forge.plugins,
                 ignores: forge.ignores,
                 context: forge.context,
                 parsesFrontmatter: parsesFrontmatter)
  })
}
