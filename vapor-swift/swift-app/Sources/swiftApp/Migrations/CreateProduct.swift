import Fluent

struct CreateProduct: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("products")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required)
            .field("price", .double, .required)
            .field("category_id", .uuid, .required, .references("categories", "id"))
            .field("brand_id", .uuid, .required, .references("brands", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("products").delete()
    }
}
