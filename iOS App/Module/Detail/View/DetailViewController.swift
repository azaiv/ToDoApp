import UIKit

protocol DetailViewProtocol: AnyObject {
    
    func show(isEditable: Bool, task: TaskEntity)
    
}

class DetailViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<DetailSections, Items>
    typealias Snapshot = NSDiffableDataSourceSnapshot<DetailSections, Items>
    
    private var dataSource: DataSource! = nil
    private var snapshot: Snapshot! = nil
    
    var presenter: DetailPresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(DetailTextFieldCell.self, forCellReuseIdentifier: DetailTextFieldCell.stringID)
        tableView.register(DetailDateCell.self, forCellReuseIdentifier: DetailDateCell.stringID)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "defaultHeader")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var saveButton = CustomButton()
    private lazy var closeButton = UIButton(type: .close)
    
    private var task: TaskEntity!
    private var isEditable: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoaded()
        
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.navigationItem.rightBarButtonItem = .init(customView: closeButton)
        self.title = self.isEditable ? Texts.Detail.NAVIGATION_TITLE_EDIT : Texts.Detail.NAVIGATION_TITLE_CREATE
        self.saveButton.setTitle(
            self.isEditable ? Texts.Detail.BUTTONT_EDIT_TITLE : Texts.Detail.BUTTON_SAVE_TITLE,
            for: .normal)
        self.saveButton.isEnabled = !self.task.title.isEmpty
        
        closeButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTappedDetailButton), for: .touchUpInside)
        
        configureDataSource()
        applySnapshot()
        hideKeyboardWhenTappedAround()
        
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            switch item {
            case .task(_ , let text):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTextFieldCell.stringID, for: indexPath) as? DetailTextFieldCell else {
                    return UITableViewCell()
                }
                cell.textView.tag = self.dataSource.sectionIdentifier(for: indexPath.section) == .title ? 0 : 1
                cell.cellDelegate = self
                cell.configure(text: text)
                return cell
            case .date(_ , text: let date):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailDateCell.stringID, for: indexPath) as? DetailDateCell else {
                    return UITableViewCell()
                }
                cell.configure(date: date)
                cell.cellDelegate = self
                return cell
            }
        })
        
        dataSource.defaultRowAnimation = .fade
    }
    
    private func applySnapshot() {
        snapshot = Snapshot()

        snapshot.appendSections([.title, .description, .date])
        snapshot.appendItems([.task(id: UUID(), text: self.task.title)], toSection: .title)
        snapshot.appendItems([.task(id: UUID(), text: self.task.details ?? "")], toSection: .description)
        snapshot.appendItems([.date(id: UUID(), text: self.task.creationDate ?? .now)], toSection: .date)
        
        dataSource.apply(snapshot)
    }
    
    @objc private func didTappedDetailButton() {

        if self.isEditable {
            presenter?.didTappedUpdateTask(
                task: self.task)
        } else {
            presenter?.didTappedSaveTask(
                task: self.task)
        }

    }
    
    @objc private func dismissController() {
        presenter?.didTappedCloseVC()
    }
    
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "defaultHeader")
        header?.textLabel?.text = dataSource.sectionIdentifier(for: section)?.headerTitle
        return header
    }
    
}

extension DetailViewController: DetailCellTextFieldProtocol {

    func updateHeightOfRow(_ cell: DetailTextFieldCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tableView.sizeThatFits(CGSize(width: size.width,
                                                    height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let thisIndexPath = tableView.indexPath(for: cell) {
                tableView.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func getTitle(text: String) {
        self.task.title = text
        
        DispatchQueue.main.async {
            self.saveButton.isEnabled = !self.task.title.isEmpty
        }
    }
    
    func getDetail(text: String) {
        self.task.details = text
    }
    
}

extension DetailViewController: DetailDateCellProtocol {
    
    func getDate(date: Date) {
        self.task.creationDate = date
    }
    
}


extension DetailViewController: DetailViewProtocol {
    
    func show(isEditable: Bool,
              task: TaskEntity) {
        self.isEditable = isEditable
        self.task = task
    }
    
}

