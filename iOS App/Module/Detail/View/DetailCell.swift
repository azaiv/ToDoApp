import UIKit

protocol DetailCellProtocol: AnyObject {
    func getTitle(text: String)
    func getDetail(text: String)
    func updateHeightOfRow(_ cell: DetailCell, _ textView: UITextView)
}

final class DetailCell: UITableViewCell {
    
    weak var cellDelegate: DetailCellProtocol?
    
    static let stringID = "DetailCell"
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func configure(text: String? = nil) {
        
        selectionStyle = .none
        
        contentView.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor)
        ])
        
        textView.text = text
    }
    
}

extension DetailCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if let delegate = cellDelegate {
            delegate.updateHeightOfRow(self, textView)
            textView.tag == 0 ? delegate.getTitle(text: textView.text) : delegate.getDetail(text: textView.text)
        }
    }
}
