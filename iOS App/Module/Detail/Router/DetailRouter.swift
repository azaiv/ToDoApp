import Foundation
import UIKit

protocol DetailRouterProtocol: AnyObject {
    func didTappedCloseVC(callback: @escaping (() -> ()))
}

class DetailRouter: DetailRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func didTappedCloseVC(callback: @escaping (() -> ())) {
        viewController?.dismiss(
            animated: true,
            completion: {
                callback()
            })
    }
}
