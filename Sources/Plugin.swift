import PathKit

public protocol Plugin {
    func run(site: Site) throws
}
