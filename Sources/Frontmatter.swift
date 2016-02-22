import Foundation
import Yaml
import PathKit

class Frontmatter {
  private let data: NSData
  private let tag: NSData
  private var contents: NSData?
  private var frontmatter: [Yaml : Yaml]?

  init(data: NSData, tag: NSData) {
    self.data = data
    self.tag = tag
  }

  func parse() -> (NSData, [Yaml : Yaml])? {
    defer {
      if contents == nil {
        contents = data
      }
    }

    guard containsStartingFrontmatterTag else { return nil }
    guard let endRange = rangeOfTerminatingFrontmatterTag else { return nil }

    let bodyRange = NSRange(NSMaxRange(endRange) ..< data.length)   
    let body = data.subdataWithRange(bodyRange)
    
    self.contents = body

    let yamlRange = NSRange(tag.length ..< endRange.location)
    let yamlData = data.subdataWithRange(yamlRange)

    // TODO: Support Non UTF8
    let string = String(data: yamlData, encoding: NSUTF8StringEncoding)
    if let string = string, frontmatter = Yaml.load(string as String).value?.dictionary {
      self.frontmatter = frontmatter
    }

    return result
  }

  var result: (NSData, [Yaml : Yaml]) {
    if contents == nil { parse() }

    return (contents!, frontmatter ?? [:])
  }

  var containsStartingFrontmatterTag: Bool {
    let minimumLength = tag.length * 2
    let length = data.length
    guard length >= minimumLength else { return false }
    guard data.subdataWithRange(NSRange(0 ..< tag.length)) == tag else { return false }
    return true
  }

  var rangeOfTerminatingFrontmatterTag: NSRange? {
    let queryRange = NSRange(tag.length ..< data.length)
    let endRange = data.rangeOfData(tag, options: [], range: queryRange)
    return endRange
  }

  static func application(tag: NSData) -> Plugin {
    return { filesMap, sorbetto in
      var newMap = [Path : File]()
      for (key, value) in filesMap {
        let parser = Frontmatter(data: value.contents, tag: tag)
        newMap[key] = File(contents: parser.result.0, context: parser.result.1)
      }

      return (newMap, sorbetto)
    }
  }
}
