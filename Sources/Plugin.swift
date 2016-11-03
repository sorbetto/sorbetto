import PathKit

public protocol Plugin {
    func run(site: Site, completionHandler: (Error?) -> Void)
}
