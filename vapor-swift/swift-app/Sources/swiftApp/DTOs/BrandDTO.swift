import Fluent
import Vapor

struct BrandDTO: Content {
    var id: Int?
    var name: String?

    func toModel() -> Brand {
        let model = Brand()

        if let name = self.name {
            model.name = name
        }
        return model
    }
}
