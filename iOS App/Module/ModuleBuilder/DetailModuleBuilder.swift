import UIKit

class DetailModuleBuilder {
    
    static func build(task: TaskEntity?) -> UIViewController {
        let interactor = DetailInteractor(taskEntity: task)
        let router = DetailRouter()
        let presenter = DetailPresenter(router: router,
                                        interactor: interactor)
        let detailVC = DetailViewController()
        detailVC.presenter = presenter
        presenter.view = detailVC
        interactor.presenter = presenter
        router.viewController = detailVC
        return UINavigationController(rootViewController: detailVC)
    }
    
}
