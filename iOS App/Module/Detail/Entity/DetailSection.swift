import Foundation

enum DetailSections: CaseIterable {
    
    case title
    case description
    
    var headerTitle: String {
        switch self {
        case .title:
            Texts.Detail.SECTION_HEADER_TITLE
        case .description:
            Texts.Detail.SECTION_HEADER_DESCRIPTION
        }
    }
}

enum Items: Hashable {
    case task(id: UUID = UUID(), text: String)
}

struct DetailSection: Hashable {
    let type: MainSections
    let item: Items
}

