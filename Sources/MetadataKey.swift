public struct MetadataKey: Equatable, Hashable, RawRepresentable {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public var hashValue: Int {
        return rawValue.hashValue
    }

    public static func ==(lhs: MetadataKey, rhs: MetadataKey) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
