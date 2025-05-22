import Fluent

struct CreateCategory: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("categories")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("categories").delete()
    }
}
