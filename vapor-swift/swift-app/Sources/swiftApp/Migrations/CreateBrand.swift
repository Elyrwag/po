import Fluent

struct CreateBrand: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("brands")
            .field("id", .int, .identifier(auto: true))
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("brands").delete()
    }
}
