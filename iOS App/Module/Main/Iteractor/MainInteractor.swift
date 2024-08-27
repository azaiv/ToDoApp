import Foundation

protocol MainInteractorProtocol: AnyObject {

    func loadDummyJson()
    func loadTasks()
    func doneTask(task: TaskEntity)
    func removeTask(task: TaskEntity)
    
}

class MainInteractor: MainInteractorProtocol {

    weak var presenter: MainPresenterProtocol?
    
    private let networkService = NetworkService()
    private let storageService = StorageService.shared

    func loadDummyJson() {
        networkService.fetchTodos(callback: { [weak self] in
            self?.storageService.fetchTasks(completion: { tasks in
                self?.presenter?.didLoadTasks(tasks: tasks)
            })
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
