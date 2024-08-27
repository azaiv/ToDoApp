import Foundation

protocol DetailPresenterProtocol: AnyObject {

    func viewDidLoaded()
    func getTaskEntity()
    func didTappedSaveTask(task: TaskEntity)
    func didTappedUpdateTask(task: TaskEntity)
    func didTappedCloseVC()
    
}

class DetailPresenter {
    
    private let storageService = StorageService.shared
    
    weak var view: DetailViewProtocol?
    var router: DetailRouterProtocol
    var interactor: DetailInteractorProtocol
    
    init(router: DetailRouterProtocol,
         interactor: DetailInteractorProtocol) {
        
        self.router = router
        self.interactor = interactor
        
    }
    
}

extension DetailPresenter: DetailPresenterProtocol {
    
    func viewDidLoaded() {
        view?.show(isEditable: interactor.isEditable,
                   task: interactor.getTask())
    }
    
    func didTappedSaveTask(task: TaskEntity) {
        storageService.addTask(
            task: task,
            completion: { isSuccess in
                self.router.didTappedCloseVC(callback: {
                    if isSuccess {
                        NotificationCenter.default.post(name: .init("updateTable"), object: nil)
                    }
                })
            })
    }
    
    func didTappedUpdateTask(task: TaskEntity) {
        storageService.updateTask(
            task: task,
            completion: { isSuccess in
                self.router.didTappedCloseVC {
                    if isSuccess {
                        NotificationCenter.default.post(name: .init("updateTable"), object: nil)
                    }
                }
            })
    }
    
    func getTaskEntity() {
//        let task = interactor.getTask()
//        view?.
    }
    
    func didTappedCloseVC() {
        router.didTappedCloseVC(callback: {
            
        })
    }
    
}
