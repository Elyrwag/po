import Fluent
import Vapor

struct ProductDTO: Content {
    var id: Int?
    var name: String?
    var price: Double?
    var categoryID: Int?
    var brandID: Int?

    var category: CategoryDTO?
    var brand: BrandDTO?

    func toModel() -> Product {
        let model = Product()

        if let name = self.name {
            model.name = name
        }
        if let price = self.price {
            model.price = price
        }
        if let categoryID = self.categoryID {
            model.$category.id = categoryID
        }
        if let brandID = self.brandID {
            model.$brand.id = brandID
        }
        return model
    }
}
