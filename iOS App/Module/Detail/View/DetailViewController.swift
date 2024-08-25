import UIKit

protocol DetailViewProtocol: AnyObject {

    
}

class DetailViewController: UIViewController {

    var presenter: DetailPresenterProtocol?
    
    private lazy var titleTextField = CustomTextField(placeholder: "Set title task")
    
    private lazy var detailTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 8
        textView.layer.cornerCurve = .continuous
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var saveButton = CustomButton(title: "Save")
    
    private lazy var closeButton = UIButton(type: .close)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
  
        self.saveButton.isEnabled = !titleTextField.text!.isEmpty
    }

    private func setupView() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleTextField)
        view.addSubview(detailTextView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            
            detailTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            detailTextView.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor),
            detailTextView.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor),
            detailTextView.heightAnchor.constraint(equalToConstant: view.frame.height / 2)
        ])
        
        self.navigationItem.rightBarButtonItem = .init(customView: closeButton)
        closeButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTaskAndDismiss), for: .touchUpInside)
        titleTextField.returnKeyType = .done
        
    }
    
    @objc private func saveTaskAndDismiss() {
        presenter?.didTappedSaveTask(
            task: .init(id: UUID(),
                        title: titleTextField.text!,
                        details: detailTextView.text,
                        creationDate: .now,
                        isDone: false))
    }
    
    @objc private func dismissController() {
        presenter?.didTappedCloseVC()
    }
 
    
}


extension DetailViewController: DetailViewProtocol {

}

