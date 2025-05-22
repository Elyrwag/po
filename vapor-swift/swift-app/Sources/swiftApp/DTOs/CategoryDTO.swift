import Fluent
import Vapor

struct CategoryDTO: Content {
    var id: Int?
    var name: String?

    func toModel() -> Category {
        let model = Category()

        if let name = self.name {
            model.name = name
        }
        return model
    }
}
