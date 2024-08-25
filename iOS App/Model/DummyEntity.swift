import Foundation

struct DummyEntity: Codable {
    let todos: [DymmyToDo]
    let total, skip, limit: Int
}

struct DymmyToDo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
