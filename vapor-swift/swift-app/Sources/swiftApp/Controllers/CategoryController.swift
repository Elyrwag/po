import Fluent
import Vapor
import Redis

struct CategoryController: RouteCollection {
    private func cacheCategory(_ category: Category, on app: Application) throws {
        let key: RedisKey = "category:\(category.id!)"
        let data = try JSONEncoder().encode(category)
        _ = app.redis.set(key, to: data)
    }

    private func getCachedCategory(id: Int, on app: Application) throws -> Category? {
        let key: RedisKey = "category:\(id)"
        if let data = try app.redis.get(key, as: Data.self).wait() {
            return try JSONDecoder().decode(Category.self, from: data)
        }
        return nil
    }

    func boot(routes: any RoutesBuilder) throws {
        let categories = routes.grouped("categories")

        categories.get(use: self.showAll)
        categories.get("create", use: self.createPage)
        categories.post("create", use: self.create)
        categories.group(":categoryID") { category in
            category.get(use: self.show)
            category.get("edit", use: self.edit)
            category.post("edit", use: self.update)
            category.post("delete", use: self.delete)
        }
    }

    @Sendable
    func showAll(req: Request) async throws -> View {
        let categoryDTOs = try await Category.query(on: req.db).all().map { $0.toDTO() }
        return try await req.view.render("Categories/showAll", ["categories": categoryDTOs])
    }

    @Sendable
    func show(req: Request) async throws -> View {
        let categoryID: Int = req.parameters.get("categoryID")!

        if let cachedCategory = try getCachedCategory(id: categoryID, on: req.application) {
            req.application.logger.info("Redis: Category with ID \(categoryID) found in cache")
            return try await req.view.render("Categories/show", ["category": cachedCategory.toDTO()])
        }

        guard let category = try await Category.find(categoryID, on: req.db) else {
            throw Abort(.notFound)
        }

        try cacheCategory(category, on: req.application)

        return try await req.view.render("Categories/show", ["category": category.toDTO()])
    }

    @Sendable
    func createPage(req: Request) async throws -> View {
        return try await req.view.render("Categories/create")
    }

    @Sendable
    func create(req: Request) async throws -> Response {
        let category = try req.content.decode(CategoryDTO.self).toModel()

        try await category.save(on: req.db)
        return req.redirect(to: "/categories")
    }

    @Sendable
    func edit(req: Request) async throws -> View {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }

        return try await req.view.render("Categories/edit", ["category": category.toDTO()])
    }

    @Sendable
    func update(req: Request) async throws -> Response {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedData = try req.content.decode(CategoryDTO.self)

        if let name = updatedData.name {
            category.name = name
        }

        try await category.save(on: req.db)
        try cacheCategory(category, on: req.application)

        return req.redirect(to: "/categories")
    }

    @Sendable
    func delete(req: Request) async throws -> Response {
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }

        do {
            try await category.delete(on: req.db)

            let key: RedisKey = "category:\(category.id!)"
            _ = req.redis.delete(key)

            return req.redirect(to: "/categories")
        } catch {
            if error.localizedDescription.contains("FOREIGN KEY constraint failed") {
                return try await req.view.render("error", ["error": "Nie można usunąć kategorii, ponieważ są z nią powiązane produkty."]).encodeResponse(for: req)
            } else {
                throw error
            }
        }
    }
}
