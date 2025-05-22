import NIOSSL
import Fluent
import FluentSQLiteDriver
import Leaf
import Vapor
import Redis

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 80

    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateProduct())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateBrand())
    try await app.autoMigrate()

    app.views.use(.leaf)
    app.redis.configuration = try RedisConfiguration(hostname: "0.0.0.0")

    // register routes
    try routes(app)
}
