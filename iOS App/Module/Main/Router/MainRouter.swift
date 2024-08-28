import Foundation
import UIKit

protocol MainRouterProtocol: AnyObject {
    func detailVC(task: TaskEntity?)
}

class MainRouter: MainRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func detailVC(task: TaskEntity?) {
        let detailVC = DetailModuleBuilder.build(task: task)
        if let sheetController = detailVC.sheetPresentationController {
            sheetController.detents = [.medium(), .large()]
            sheetController.preferredCornerRadius = 22
            sheetController.prefersGrabberVisible = true
        }
        viewController?.present(detailVC, animated: true)
    }
    
}
