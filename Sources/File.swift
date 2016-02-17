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
  private var sizeDescription: String {
    let KB_PER_B = 1024
    let MB_PER_B = 1024 * 1024
    let GB_PER_B = 1024 * 1024 * 1024

    let length = contents.length
    if length > GB_PER_B {
      return "\(length / GB_PER_B) GiB"
    } else if length > MB_PER_B {
      return "\(length / MB_PER_B) MiB"
    } else if length > KB_PER_B {
      return "\(length / KB_PER_B) KiB"
    } else {
      return "\(length) B"
    }
  }

  public var description: String {
    return "\(path) (\(sizeDescription))"
  }
}
