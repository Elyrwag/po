import Fluent
import Vapor
import Redis

struct BrandController: RouteCollection {
    private func cacheBrand(_ brand: Brand, on app: Application) throws {
        let key: RedisKey = "brand:\(brand.id!)"
        let data = try JSONEncoder().encode(brand)
        _ = app.redis.set(key, to: data)
    }

    private func getCachedBrand(id: Int, on app: Application) throws -> Brand? {
        let key: RedisKey = "brand:\(id)"
        if let data = try app.redis.get(key, as: Data.self).wait() {
            return try JSONDecoder().decode(Brand.self, from: data)
        }
        return nil
    }

    func boot(routes: any RoutesBuilder) throws {
        let brands = routes.grouped("brands")

        brands.get(use: self.showAll)
        brands.get("create", use: self.createPage)
        brands.post("create", use: self.create)
        brands.group(":brandID") { brand in
            brand.get(use: self.show)
            brand.get("edit", use: self.edit)
            brand.post("edit", use: self.update)
            brand.post("delete", use: self.delete)
        }
    }

    @Sendable
    func showAll(req: Request) async throws -> View {
        let brandDTOs = try await Brand.query(on: req.db).all().map { $0.toDTO() }
        return try await req.view.render("Brands/showAll", ["brands": brandDTOs])
    }

    @Sendable
    func show(req: Request) async throws -> View {
        let brandID: Int = req.parameters.get("brandID")!

        if let cachedBrand = try getCachedBrand(id: brandID, on: req.application) {
            req.application.logger.info("Redis: Brand with ID \(brandID) found in cache")
            return try await req.view.render("Brands/show", ["brand": cachedBrand.toDTO()])
        }

        guard let brand = try await Brand.find(brandID, on: req.db) else {
            throw Abort(.notFound)
        }

        try cacheBrand(brand, on: req.application)

        return try await req.view.render("Brands/show", ["brand": brand.toDTO()])
    }

    @Sendable
    func createPage(req: Request) async throws -> View {
        return try await req.view.render("Brands/create")
    }

    @Sendable
    func create(req: Request) async throws -> Response {
        let brand = try req.content.decode(BrandDTO.self).toModel()

        try await brand.save(on: req.db)
        return req.redirect(to: "/brands")
    }

    @Sendable
    func edit(req: Request) async throws -> View {
        guard let brand = try await Brand.find(req.parameters.get("brandID"), on: req.db) else {
            throw Abort(.notFound)
        }

        return try await req.view.render("Brands/edit", ["brand": brand.toDTO()])
    }

    @Sendable
    func update(req: Request) async throws -> Response {
        guard let brand = try await Brand.find(req.parameters.get("brandID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedData = try req.content.decode(BrandDTO.self)

        if let name = updatedData.name {
            brand.name = name
        }

        try await brand.save(on: req.db)
        try cacheBrand(brand, on: req.application)

        return req.redirect(to: "/brands")
    }

    @Sendable
    func delete(req: Request) async throws -> Response {
        guard let brand = try await Brand.find(req.parameters.get("brandID"), on: req.db) else {
            throw Abort(.notFound)
        }

        do {
            try await brand.delete(on: req.db)

            let key: RedisKey = "brand:\(brand.id!)"
            _ = req.redis.delete(key)

            return req.redirect(to: "/brands")
        } catch {
            if error.localizedDescription.contains("FOREIGN KEY constraint failed") {
                return try await req.view.render("error", ["error": "Nie można usunąć marki, ponieważ są z nią powiązane produkty."]).encodeResponse(for: req)
            } else {
                throw error
            }
        }
    }
}
