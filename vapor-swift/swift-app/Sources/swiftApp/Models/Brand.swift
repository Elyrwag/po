import Fluent

final class Brand: Model, @unchecked Sendable {
    static let schema = "brands"

    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "name")
    var name: String

    @Children(for: \.$brand)
    var products: [Product]

    init() { }

    init(name: String) {
        self.name = name
    }

    func toDTO() -> BrandDTO {
        .init(
            id: self.id,
            name: self.name
        )
    }
}
