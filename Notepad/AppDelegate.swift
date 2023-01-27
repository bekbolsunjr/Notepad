import UIKit
import UniformTypeIdentifiers

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        

        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        router.initialViewController(fileUrl: nil)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
