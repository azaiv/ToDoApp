import Foundation

enum DetailSections: CaseIterable {
    case title
    case description
}

enum Items: Hashable {
    case task(id: UUID = UUID(), text: String)
}

struct DetailSection: Hashable {
    let type: Sections
    let item: Items
}

