import Foundation
import UIKit

protocol MainRouterProtocol: AnyObject {
    func detailVC(task: TaskEntity?)
}

class MainRouter: MainRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func detailVC(task: TaskEntity?) {
        let detailVC = DetailModuleBuilder.build(task: task)
        viewController?.present(detailVC, animated: true)
    }
    
}
