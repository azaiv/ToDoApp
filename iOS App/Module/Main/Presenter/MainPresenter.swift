import Foundation

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoaded()
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
    
    init(router: MainRouterProtocol, 
         interactor: MainInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
}

extension MainPresenter: MainPresenterProtocol {

    func viewDidLoaded() {
        if !UserDefaults.standard.bool(forKey: Constants.Defaults.IS_LOADED_DUMMY) {
            interactor.loadDummyJson()
        } else {
            interactor.loadTasks()
        }
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
        router.detailVC(task: nil)
    }
    
    func didTappedDoneTask(task: TaskEntity) {
        interactor.doneTask(task: task)
    }

}
