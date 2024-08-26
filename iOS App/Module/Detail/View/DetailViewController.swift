import UIKit

protocol DetailViewProtocol: AnyObject {
    
    
}

class DetailViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<DetailSections, Items>
    typealias Snapshot = NSDiffableDataSourceSnapshot<DetailSections, Items>
    
    private var dataSource: DataSource! = nil
    private var snapshot: Snapshot! = nil
    
    var presenter: DetailPresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(DetailCell.self, forCellReuseIdentifier: DetailCell.stringID)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "defaultHeader")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var saveButton = CustomButton(title: "Save")
    private lazy var closeButton = UIButton(type: .close)
    
    private var taskTitle: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.saveButton.isEnabled = !self.taskTitle.isEmpty
            }
        }
    }
    private var taskDetail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoaded()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
  
        self.saveButton.isEnabled = !taskTitle.isEmpty
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
        self.title = "Task"
        closeButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTaskAndDismiss), for: .touchUpInside)
        configureDataSource()
        applySnapshot()
        
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            switch item {
            case .task(_ , let text):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.stringID, for: indexPath) as? DetailCell else {
                    return UITableViewCell()
                }
                cell.textView.tag = self.dataSource.sectionIdentifier(for: indexPath.section) == .title ? 0 : 1
                cell.cellDelegate = self
                cell.configure(text: text)
                return cell
            }
        })
        
        dataSource.defaultRowAnimation = .fade
    }
    
    private func applySnapshot() {
        snapshot = Snapshot()
        
        let task = presenter?.getTaskEntity()
        
        snapshot.appendSections([.title, .description])
        snapshot.appendItems([.task(id: UUID(), text: task?.title ?? "")], toSection: .title)
        snapshot.appendItems([.task(id: UUID(), text: task?.details ?? "")], toSection: .description)
        
        dataSource.apply(snapshot)
    }
    
    @objc private func saveTaskAndDismiss() {
        presenter?.didTappedSaveTask(
            task: .init(id: UUID(),
                        title: taskTitle,
                        details: taskDetail,
                        creationDate: .now,
                        isDone: false))
    }
    
    @objc private func dismissController() {
        presenter?.didTappedCloseVC()
    }
    
    
}

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let section = dataSource.sectionIdentifier(for: section)
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "defaultHeader") else { return nil }
        
        switch section {
        case .title:
            header.textLabel?.text = "Title"
        case .description:
            header.textLabel?.text = "Description"
        case .none:
            return nil
        }
        return header
    }
    
}

extension DetailViewController: DetailCellProtocol {

    func updateHeightOfRow(_ cell: DetailCell, _ textView: UITextView) {
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
        self.taskTitle = text
    }
    
    func getDetail(text: String) {
        self.taskDetail = text
    }
    
}


extension DetailViewController: DetailViewProtocol {
    
}

