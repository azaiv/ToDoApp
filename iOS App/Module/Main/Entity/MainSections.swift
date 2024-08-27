import Foundation

enum MainSections: CaseIterable {
    case notDone
    case isDone
    
    var headerTitle: String {
        switch self {
        case .notDone:
            Texts.Main.NOT_COMPLETED_HEADER
        case .isDone:
            Texts.Main.COMPLETED_HEADER
        }
    }
}

enum TaskItem: Hashable {
    case task(item: TaskEntity)
}

struct MainSection: Hashable {
    let type: MainSections
    let item: [TaskItem]
}
