import UIKit

final class PrintController {
    //MARK: - Properties
    private let text: String
    private let font: UIFont
    private let printModel: PrintModel
    
    //MARK: - Initialize
    init(printViewer: PrintViewer,
         text: String, font: UIFont) {
        self.text = text
        self.font = font
        printModel = PrintModel(printViewer: printViewer)
       
    }
    
    //MARK: - Methods
    func callPrint(text: String, font: UIFont) {
        printModel.createImage(text: text, font: font)
    }
}
