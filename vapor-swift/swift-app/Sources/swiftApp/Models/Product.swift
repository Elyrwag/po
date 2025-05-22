import Fluent

final class Product: Model, @unchecked Sendable {
    static let schema = "products"

    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "name")
    var name: String

    @Field(key: "price")
    var price: Double

    @Parent(key: "category_id")
    var category: Category

    @Parent(key: "brand_id")
    var brand: Brand

    init() { }

    init(name: String, price: Double, categoryId: Int, brandId: Int) {
        self.name = name
        self.price = price
        self.$category.id = categoryId
        self.$brand.id = brandId
    }

    func toDTO(includeRelations: Bool = false) -> ProductDTO {
        var dto = ProductDTO(
            id: self.id,
            name: self.name,
            price: self.price,
            categoryID: self.$category.id,
            brandID: self.$brand.id
        )

        if includeRelations {
            dto.category = CategoryDTO(id: self.category.id, name: self.category.name)
            dto.brand = BrandDTO(id: self.brand.id, name: self.brand.name)
        }

        return dto
    }
}
