import Foundation

private var MetadataKeyCounter: Int64 = 0

public final class MetadataKey<T> {
    fileprivate let id: Int64

    public init() {
        self.id = OSAtomicIncrement64Barrier(&MetadataKeyCounter)
    }
}

public struct Metadata {
    private var storage: [Int64: Any]

    public init() {
        self.storage = [:]
    }

    public func get<T>(key: MetadataKey<T>) -> T? {
        return storage[key.id] as? T
    }

    public mutating func set<T>(key: MetadataKey<T>, value: T?) {
        storage[key.id] = value
    }
}
