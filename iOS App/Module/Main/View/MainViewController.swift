import UIKit

protocol MainViewProtocol: AnyObject {
    
    var todos: DummyEntity? { get set }
    
    func showDummy(todos: DummyEntity)
    func showTasks(tasks: [TaskEntity])
    
}

class MainViewController: UIViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<Sections, TaskItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Sections, TaskItem>
    
    private var dataSource: DataSource! = nil
    private var snapshot: Snapshot! = nil
    
    var presenter: MainPresenterProtocol?
    var tasks: [TaskEntity] = []
    var todos: DummyEntity?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.stringID)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "defaultHeader")
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    private lazy var searchBarController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        presenter?.viewDidLoaded()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTasks),
            name: .init("addedTask"),
            object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        activityIndicator.startAnimating()
        
        self.title = "To Do App"
        self.navigationItem.rightBarButtonItem = .init(customView: addTaskButton)
        self.navigationItem.searchController = searchBarController
        
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        
        addTaskButton.addTarget(self, action: #selector(didTappedAddTask), for: .touchUpInside)
        
        configureDataSource()
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            switch item {
            case .task(var item):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.stringID, for: indexPath) as? MainTableViewCell
                else {
                    return UITableViewCell()
                }
                cell.configure(task: item)
                cell.doneAction = {
                    item.isDone.toggle()
                    cell.isDone = item.isDone
                    self.presenter?.didTappedDoneTask(task: item)
                }
                return cell
            }
        })
        
        dataSource.defaultRowAnimation = .fade
    }
    
    private func applySnapshot(sections: [MainSection]) {
        self.snapshot = Snapshot()
        
        for section in sections {
            snapshot.appendSections([section.type])
            snapshot.appendItems(section.item, toSection: section.type)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    private func getFilteredData(searchedText: String = String()) {
        let searchableTasks: [TaskEntity] = tasks.filter {
            $0.title.lowercased().contains(searchedText.lowercased())
        }
        
        self.updatedTasks(tasks: searchedText == "" ? tasks : searchableTasks)
    }
    
    private func updatedTasks(tasks: [TaskEntity]) {
        var notDone: [TaskItem] = []
        var isDone: [TaskItem] = []
        
        tasks.forEach({ task in
            task.isDone ? isDone.append(.task(item: task)) : notDone.append(.task(item: task))
        })
        
        self.applySnapshot(sections: [
            .init(type: .notDone, item: notDone),
            .init(type: .isDone, item: isDone)
        ])
    }
    
    @objc private func didTappedAddTask() {
        presenter?.didTappedAddTask()
    }
    
    @objc private func updateTasks() {
        presenter?.viewDidLoaded()
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let taskItem = dataSource.itemIdentifier(for: indexPath) else { return nil }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completion) in
            switch taskItem {
            case .task(let task):
                self?.presenter?.didTappedEditTask(task: task)
            }
        }
        
        editAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self] (action, view, completion) in
            switch taskItem {
            case .task(let task):
                self?.presenter?.didTappedRemoveTask(task: task)
            }
        }
        
        
        return .init(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        
        let section = Sections.allCases[section]
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "defaultHeader") else { return nil }
        
        switch section {
        case .isDone:
            header.textLabel?.text = "Done"
        case .notDone:
            header.textLabel?.text = "Not done"
        }
        return header
    }
    
}

extension MainViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        getFilteredData(searchedText: searchBar.text ?? String())
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = String()
        getFilteredData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
}


extension MainViewController: MainViewProtocol {
    
    func showDummy(todos: DummyEntity) {
        self.todos = todos
        tableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func showTasks(tasks: [TaskEntity]) {
        self.tasks = tasks
        updatedTasks(tasks: tasks)
        activityIndicator.stopAnimating()
    }
    
}
