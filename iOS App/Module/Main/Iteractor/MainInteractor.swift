import Foundation

protocol MainInteractorProtocol: AnyObject {
    
    var task: TaskEntity? { get }
    var tasks: [TaskEntity] { get set }
    
    func loadDummyJson()
    func loadTasks()
    func doneTask(task: TaskEntity)
    func removeTask(task: TaskEntity)
}

class MainInteractor: MainInteractorProtocol {

    weak var presenter: MainPresenterProtocol?
    
    private let networkService = NetworkService()
    private let storageService = StorageService.shared
    
    var task: TaskEntity? = nil
    var tasks: [TaskEntity] = []
    
    func loadDummyJson() {
        networkService.fetchTodos(completion: { [weak self] todos in
            self?.presenter?.didLoadTasks(tasks: todos)
        })
    }
    
    func loadTasks() {
        storageService.fetchTasks(completion: { [weak self] tasks in
            self?.presenter?.didLoadTasks(tasks: tasks)
        })
    }
    
    func removeTask(task: TaskEntity) {
        storageService.deleteTask(
            task: task,
            completion: { result in
                if result {
                    self.storageService.fetchTasks(completion: { [ weak self ] tasks in
                        self?.presenter?.didLoadTasks(tasks: tasks)
                    })
                }
            })
    }
    
    func doneTask(task: TaskEntity) {
        storageService.updateTask(
            task: task,
            completion: { result in
                if result {
                    self.storageService.fetchTasks(completion: { [ weak self ] tasks in
                        self?.presenter?.didLoadTasks(tasks: tasks)
                    })
                }
            })
    }
}
