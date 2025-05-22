import Fluent
import Vapor
import Redis

struct ProductController: RouteCollection {
    private func cacheProduct(_ product: Product, on app: Application) throws {
        let dto = product.toDTO(includeRelations: true)
        let key: RedisKey = "product:\(product.id!)"
        let data = try JSONEncoder().encode(dto)
        _ = app.redis.set(key, to: data)
    }

    private func getCachedProduct(id: Int, on app: Application) throws -> ProductDTO? {
        let key: RedisKey = "product:\(id)"
        if let data = try app.redis.get(key, as: Data.self).wait() {
            return try JSONDecoder().decode(ProductDTO.self, from: data)
        }
        return nil
    }

    func boot(routes: any RoutesBuilder) throws {
        let products = routes.grouped("products")

        products.get(use: self.showAll)
        products.get("create", use: self.createPage)
        products.post("create", use: self.create)
        products.group(":productID") { product in
            product.get(use: self.show)
            product.get("edit", use: self.edit)
            product.post("edit", use: self.update)
            product.post("delete", use: self.delete)
        }
    }

    @Sendable
    func showAll(req: Request) async throws -> View {
        let productDTOs = try await Product.query(on: req.db).all().map { $0.toDTO() }
        return try await req.view.render("Products/showAll", ["products": productDTOs])
    }

    @Sendable
    func show(req: Request) async throws -> View {
        let productID: Int = req.parameters.get("productID")!

        if let cachedProductDTO = try getCachedProduct(id: productID, on: req.application) {
            req.application.logger.info("Redis: Product with ID \(productID) found in cache")
            return try await req.view.render("Products/show", ["product": cachedProductDTO])
        }

        guard let product = try await Product.query(on: req.db)
            .filter(\.$id == productID)
            .with(\.$category)
            .with(\.$brand)
            .first()
        else {
            throw Abort(.notFound)
        }

        try cacheProduct(product, on: req.application)

        return try await req.view.render("Products/show", ["product": product.toDTO(includeRelations: true)])
    }

    @Sendable
    func createPage(req: Request) async throws -> View {
        let categoryDTOs: [CategoryDTO] = try await Category.query(on: req.db).all().map { $0.toDTO() }
        let brandDTOs: [BrandDTO] = try await Brand.query(on: req.db).all().map { $0.toDTO() }

        struct CreateProductContext: Encodable {
            let categories: [CategoryDTO]
            let brands: [BrandDTO]
        }

        return try await req.view.render("Products/create", CreateProductContext(categories: categoryDTOs, brands: brandDTOs))
    }

    @Sendable
    func create(req: Request) async throws -> Response {
        let product = try req.content.decode(ProductDTO.self).toModel()

        try await product.save(on: req.db)
        return req.redirect(to: "/products")
    }

    @Sendable
    func edit(req: Request) async throws -> View {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let productDTO = product.toDTO(includeRelations: false)
        let categoryDTOs: [CategoryDTO] = try await Category.query(on: req.db).all().map { $0.toDTO() }
        let brandDTOs: [BrandDTO] = try await Brand.query(on: req.db).all().map { $0.toDTO() }

        struct EditProductContext: Encodable {
            let product: ProductDTO
            let categories: [CategoryDTO]
            let brands: [BrandDTO]
        }

        return try await req.view.render("Products/edit", EditProductContext(product: productDTO, categories: categoryDTOs, brands: brandDTOs))
    }

    @Sendable
    func update(req: Request) async throws -> Response {
        let productID: Int = req.parameters.get("productID")!
        guard let product = try await Product.query(on: req.db)
            .filter(\.$id == productID)
            .with(\.$category)
            .with(\.$brand)
            .first()
        else {
            throw Abort(.notFound)
        }

        let updatedData = try req.content.decode(ProductDTO.self)

        if let name = updatedData.name {
            product.name = name
        }
        if let price = updatedData.price {
            product.price = price
        }
        if let categoryID = updatedData.categoryID {
            product.$category.id = categoryID
        }
        if let brandID = updatedData.brandID {
            product.$brand.id = brandID
        }

        try await product.save(on: req.db)
        try cacheProduct(product, on: req.application)

        return req.redirect(to: "/products")
    }

    @Sendable
    func delete(req: Request) async throws -> Response {
        guard let product = try await Product.find(req.parameters.get("productID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await product.delete(on: req.db)

        let key: RedisKey = "product:\(product.id!)"
        _ = req.redis.delete(key)

        return req.redirect(to: "/products")
    }
}
