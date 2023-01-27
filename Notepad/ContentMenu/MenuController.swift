import Foundation
import UIKit

protocol MenuControllerDelegate: AnyObject {
    func menuController(_ menuController: MenuController, didPressMenu menu: MenuOptions)
}

class MenuController {
    
    weak var delegate: MenuControllerDelegate?
    
    func numberOfMenus() -> Int {
        return MenuOptions.allCases.count
    }
    
    func menuTitle(at index: Int) -> String {
        return MenuOptions.allCases[index].rawValue
    }
    
    func menuImage(at index: Int) -> UIImage? {
        return UIImage(systemName: MenuOptions.allCases[index].imageName)
    }
    
    func menuTapped(at index: Int, in view: MenuViewer) {
        view.presentingViewController?.dismiss(animated: true, completion: {
            let menuItem = MenuOptions.allCases[index]
            self.delegate?.menuController(self, didPressMenu: menuItem)
        })
    }
}
