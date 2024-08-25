import Foundation

protocol DetailPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func getTaskEntity() -> TaskEntity
    func didTappedSaveTask(task: TaskEntity)
    func didTappedCloseVC()
}

class DetailPresenter {
    
    weak var view: DetailViewProtocol?
    var router: DetailRouterProtocol
    var interactor: DetailInteractorProtocol
    
    private let storageService = StorageService.shared
    
    
    init(router: DetailRouterProtocol, 
         interactor: DetailInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
}

extension DetailPresenter: DetailPresenterProtocol {

    func viewDidLoaded() {
        let task = interactor.getTask()
//        view
    }
    
    func didTappedSaveTask(task: TaskEntity) {
        storageService.addTask(
            task: task,
            completion: { result in
                if result {
                    self.router.didTappedCloseVC(callback: {
                        NotificationCenter.default.post(name: .init("addedTask"), object: nil)
                    })
                }
            })
    }
    
    func getTaskEntity() -> TaskEntity {
        interactor.getTask()
    }
    
    func didTappedCloseVC() {
        router.didTappedCloseVC(callback: {
            
        })
    }
    
}
