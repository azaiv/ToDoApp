import UIKit

final class MainTableViewCell: UITableViewCell {
    
    static let stringID: String = "MainTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var isDone: Bool = false
    
    var doneAction: (() -> ())?
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        doneButton.setImage(!isDone ? UIImage(systemName: "circle") : UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        doneButton.tintColor = !isDone ? .systemGray5 : .systemBlue
    }
    

    public func configure(task: TaskEntity) {
        isDone = task.isDone
        
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.centerYAnchor.constraint(equalTo: contentView.readableContentGuide.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: doneButton.leadingAnchor, constant: -5),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: detailLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor),
        ])
        
        titleLabel.text = task.title
        detailLabel.text = task.details
        dateLabel.text = task.creationDate != nil ? dateFormatter.string(from: task.creationDate!) : ""
        dateLabel.textColor = task.creationDate != nil ? (task.creationDate! > .now ? UIColor.label : UIColor.systemRed) : UIColor.label
        doneButton.addTarget(self, action: #selector(doneTappedAction), for: .touchUpInside)
    }
    
    @objc private func doneTappedAction() {
        layoutIfNeeded()
        doneAction?()
    }
    
}
