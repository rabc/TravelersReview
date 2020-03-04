import UIKit
import AppServices

enum AppScene {
    case details
}

class AppCoordinator {
    let window: UIWindow
    
    lazy var listViewController: ReviewsListViewController = {
        let viewController = ReviewsListViewController()
        viewController.loadViewIfNeeded()
        
        return viewController
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = listViewController
    }
    
    func handle(scene: AppScene) {
        
    }
}
