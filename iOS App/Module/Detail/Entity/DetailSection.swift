import Foundation

enum DetailSections: CaseIterable {
    
    case title
    case description
    case date
    
    var headerTitle: String {
        switch self {
        case .title:
            Texts.Detail.SECTION_HEADER_TITLE
        case .description:
            Texts.Detail.SECTION_HEADER_DESCRIPTION
        case .date:
            ""
        }
    }
}

enum Items: Hashable {
    case task(id: UUID = UUID(), text: String)
    case date(id: UUID = UUID(), text: Date)
}

struct DetailSection: Hashable {
    let type: MainSections
    let item: Items
}

