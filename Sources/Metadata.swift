public final class MetadataKey<T> {
    public init() {}
}

public struct Metadata {
    private var storage: [ObjectIdentifier: Any]

    public init() {
        self.storage = [:]
    }

    public func get<T>(key: MetadataKey<T>) -> T? {
        return storage[ObjectIdentifier(key)] as? T
    }

    public mutating func set<T>(key: MetadataKey<T>, value: T?) {
        storage[ObjectIdentifier(key)] = value
    }
}
