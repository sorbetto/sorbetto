public struct Lens<ObjectType, PropertyType> {
  public let from: (ObjectType) -> PropertyType
  public let to: (PropertyType, ObjectType) -> ObjectType

  public init(from: (ObjectType) -> PropertyType, to: (PropertyType, ObjectType) -> ObjectType) {
    self.from = from
    self.to = to
  }
}
