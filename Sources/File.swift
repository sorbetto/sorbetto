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

extension File: CustomStringConvertible {
  public var description: String {
    return "\"\(path)\" 0o\(String(mode, radix: 8)) <\(contents.length) byte(s)>"
  }
}
