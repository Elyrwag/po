import Fluent

final class Category: Model, @unchecked Sendable {
    static let schema = "categories"

    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "name")
    var name: String

    @Children(for: \.$category)
    var products: [Product]

    init() { }

    init(name: String) {
        self.name = name
    }

    func toDTO() -> CategoryDTO {
        .init(
            id: self.id,
            name: self.name
        )
    }
}
