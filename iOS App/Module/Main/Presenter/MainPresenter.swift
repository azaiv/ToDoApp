import Foundation

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didLoadDummy(todos: DummyEntity?)
    func didLoadTasks(tasks: [TaskEntity])
    func didTappedAddTask()
    func didTappedEditTask(task: TaskEntity)
    func didTappedRemoveTask(task: TaskEntity)
    func didTappedDoneTask(task: TaskEntity)
}

class MainPresenter {
    
    weak var view: MainViewProtocol?
    var router: MainRouterProtocol
    var interactor: MainInteractorProtocol
    
    
    init(router: MainRouterProtocol, interactor: MainInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
}

extension MainPresenter: MainPresenterProtocol {

    func viewDidLoaded() {
        if !UserDefaults.standard.bool(forKey: "isFirstStart") {
            interactor.loadDummyJson()
        } else {
            interactor.loadTasks()
        }
        
        UserDefaults.standard.setValue(true, forKey: "isFirstStart")
    }
    
    func didLoadDummy(todos: DummyEntity?) {
        guard let todos = todos else {
            return
        }
        view?.showDummy(todos: todos)
    }
    
    func didLoadTasks(tasks: [TaskEntity]) {
        view?.showTasks(tasks: tasks)
    }
    
    func didTappedRemoveTask(task: TaskEntity) {
        interactor.removeTask(task: task)
    }
    
    func didTappedEditTask(task: TaskEntity) {
        router.detailVC(task: task)
    }
    
    func didTappedAddTask() {
        router.detailVC(task: interactor.task)
    }
    
    func didTappedDoneTask(task: TaskEntity) {
        interactor.doneTask(task: task)
    }

}
