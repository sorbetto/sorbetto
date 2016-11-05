import PathKit

public protocol Plugin {
    func run(site: Site, completionHandler: @escaping (Error?) -> Void)
}
