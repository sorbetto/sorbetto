import Foundation
import Yaml

extension MetadataKey {
    static var frontmatter: MetadataKey {
        return MetadataKey("frontmatter")
    }
}

class FrontmatterParser: Plugin {
    fileprivate static let startTag: Data = {
        let tag = "---\n"
        return tag.data(using: .utf8)!
    }()

    fileprivate static let endTag: Data = {
        let tag = "\n---\n"
        return tag.data(using: .utf8)!
    }()

    func run(site: Site, completionHandler: (Error?) -> Void) {
        for path in site.paths {
            guard let file = site[path] else {
                // A path in `site.paths` should never return a nil file.
                continue
            }

            let contents = file.contents
            guard let startRange = contents.range(of: FrontmatterParser.startTag, options: .anchored) else {
                // Continue if file does not start with frontmatter tag
                continue
            }

            guard let endRange = contents.range(of: FrontmatterParser.endTag, in: startRange.upperBound ..< contents.count) else {
                // Continue if file does not have frontmatter end tag
                continue
            }

            let frontmatterData = contents.subdata(in: startRange.lowerBound ..< endRange.lowerBound)
            guard let frontmatterString = String(data: frontmatterData, encoding: .utf8) else {
                // Continue if the frontmatter cannot be converted from data to string
                continue
            }

            do {
                file.metadata[.frontmatter] = try Yaml.load(frontmatterString)
            } catch {
                // A parsing error ocurred. Assume no frontmatter.
                continue
            }

            file.contents = contents.subdata(in: endRange.upperBound ..< contents.count)
        }

        completionHandler(nil)
    }
}
