import Fluent
import Vapor
import Leaf

func routes(_ app: Application) throws {
    app.get { req async throws -> View in
        try await req.view.render("home")
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    try app.register(collection: ProductController())
    try app.register(collection: CategoryController())
    try app.register(collection: BrandController())
}
