import Foundation

struct TaskEntity: Hashable {
    var id: UUID
    var title: String
    var details: String?
    var creationDate: Date
    var isDone: Bool
}
