import UIKit

protocol DetailDateCellProtocol: AnyObject {
    func getDate(date: Date)
}

final class DetailDateCell: UITableViewCell {

    static let stringID = "DetailDateCell"
    
    weak var cellDelegate: DetailDateCellProtocol?

    private lazy var datePicker: UIDatePicker = {
        let datepicker = UIDatePicker()
        datepicker.date = .now
        datepicker.calendar = .current
        datepicker.datePickerMode = .dateAndTime
        datepicker.minimumDate = .now
        datepicker.translatesAutoresizingMaskIntoConstraints = false
        return datepicker
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    func configure(date: Date? = nil) {
        
        selectionStyle = .none
        
        contentView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
            datePicker.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: contentView.readableContentGuide.bottomAnchor)
        ])
        
        self.textLabel?.text = Texts.Detail.ROW_DATE_TITLE

        self.datePicker.date = date ?? .now
        self.datePicker.addTarget(self, action: #selector(dateChanged(_ :)), for: .valueChanged)
        
    }

    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [flexibleSpace, done]
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        if let delegate = cellDelegate {
            delegate.getDate(date: sender.date)
        }
    }
    
    @objc private func dismissAction() {
        endEditing(true)
    }
    
}

