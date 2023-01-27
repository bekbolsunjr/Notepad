import UIKit

final class PrintViewer: UIViewController {
    //MARK: - Properties
    private var printController: PrintController?
    private let printInteractionController: UIPrintInteractionController
    
    //MARK: - Initialize
    init(text: String, font: UIFont) {
        printInteractionController = UIPrintInteractionController.shared
        super.init(nibName: nil, bundle: nil)
        printController = PrintController(printViewer: self, text: text, font: font)
        printController?.callPrint(text: text, font: font)
        printInteractionController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        printInteractionController.present(animated: true)
    }
    
    //MARK: - Methods
    func presentPrintInteractionController() {
        printInteractionController.present(animated: true)
    }

    func launchPrint(image: [UIImage]) {
        
        let printInfo = UIPrintInfo(dictionary: nil)
        
        printInfo.jobName = "Printing ..."
        printInfo.outputType = .general
        
        printInteractionController.printInfo = printInfo
        
        printInteractionController.printingItems = image
    }
}

//MARK: - UIPrintInteractionControllerDelegate
extension PrintViewer: UIPrintInteractionControllerDelegate {
    
    func printInteractionControllerDidFinishJob(_: UIPrintInteractionController) {
        let alert = UIAlertController.callStandartAlert(title: "Text was printed",
                                                        message: "", completion: { [weak self] in
            self?.dismiss(animated: true)
        })

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
}
