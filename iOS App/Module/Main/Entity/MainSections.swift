import Foundation

enum Sections: CaseIterable {
    case notDone
    case isDone
}

enum TaskItem: Hashable {
    case task(item: TaskEntity)
}

struct MainSection: Hashable {
    let type: Sections
    let item: [TaskItem]
}
