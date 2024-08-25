import UIKit

class MainModuleBuilder {
    
    static func build() -> UIViewController {
        let interactor = MainInteractor()
        let router = MainRouter()
        let presenter = MainPresenter(router: router,
                                       interactor: interactor)
        let mainVC = MainViewController()
        mainVC.presenter = presenter
        presenter.view = mainVC
        interactor.presenter = presenter
        router.viewController = mainVC
        return mainVC
    }
    
}
