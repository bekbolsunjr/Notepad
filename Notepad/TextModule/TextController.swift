import Foundation
import UIKit


class TextController: NSObject {
    
    // MARK: Properties
    private var fileUrl: URL?
    private let textViewer: TextViewer
    private let fileManager: FileManagerModel
    private let router: RouterProtocol
    private let careTaker: CareTaker
    
    //MARK: - Initializer
    init(textViewer: TextViewer,
         fileUrl: URL?,
         router: RouterProtocol) {
        self.textViewer = textViewer
        self.fileManager = FileManagerModel()
        self.router = router
        self.fileUrl = fileUrl
        careTaker = CareTaker(textWriter: textViewer)
        careTaker.save()
        
        super.init()
        openDocument()
    }
    
    // MARK: Public methods
    /// отменяет последнее действие
    func undoDidTap() {
        careTaker.undo()
    }
    
    /// возвращает последние изменения
    func redoDidTap() {
        careTaker.redo()
    }
    
    /// сохраняет состояние
    func careTakerSave() {
        careTaker.save()
    }
    
    /// показывет меню
    ///  - barButtonItem: кнопка из которой появляется меню
    func showMenu(barButtonItem: UIBarButtonItem) {
        router.showContentMenu(over: barButtonItem, delegate: self)
    }
    
    /// возвращает TextViewer
    func getViewer() -> TextViewer {
        return textViewer
    }
    
    /// открывает директорию со всеми документами приложения
    func openAnotherDocument() {
        router.pushDocumentViewer()
    }
    
    // MARK: Private methods
    /// открывает  файлы из папки приложения
    private func openDocument() {
        textViewer.navigationController?.pushViewController(DocumentViewer(), animated: true)
        careTaker.removeStates()
        if let fileUrl = fileUrl {
            let text = fileManager.openFile(fileUrl)
            // Для чтение по символам закоментируйте верхнюю линию и расскоментируйте нижнюю
            // let text = fileManager.readFileByCharacter(fileUrl)
            textViewer.updateTextView(text: text)
            textViewer.updateTitle(fileTitle: fileUrl.lastPathComponent)
        } else {
            textViewer.updateTitle(fileTitle: "Untitled")
        }
    }
    
    /// сохраняет новые файлы
    private func save() {
        if let fileUrl = fileUrl {
            fileManager.save(fileUrl: fileUrl, content: self.textViewer.getText())
        } else {
            saveAs()
        }
    }
    
    /// пересохраняет файлы с новыми названиями и расширениями
    private func saveAs() {
        let alert = UIAlertController.createGetFileNameAlert(
            textFieldDelegate: self,
            completion: { alertController, fileName in
                let fileUrl = self.fileManager.generateFileUrl(fileName: fileName)
                
                let performReplace = {
                    self.fileManager.save(fileUrl: fileUrl, content: self.textViewer.getText())
                    self.fileUrl = fileUrl
                    self.textViewer.updateTitle(fileTitle: fileUrl.lastPathComponent)
                }
                
                if self.fileManager.fileExists(fileUrl) {
                    let renameReplaceAlert = UIAlertController.createRenameOrOverwriteAlert(
                        onRename: {
                            self.textViewer.present(alertController, animated: true)
                        },
                        onReplace: {
                            performReplace()
                        })
                    self.textViewer.present(renameReplaceAlert, animated: true)
                } else {
                    performReplace()
                }
            })
        
        textViewer.present(alert, animated: true)
    }
    /// открывает окно распечатки
    private func printText() {
        let alert = UIAlertController.callStandartAlert(title: "Warning.",
                                                        message: "You can't print empty page!")
        if textViewer.getText().isEmpty {
            textViewer.presentAlert(alert: alert)
        } else {
            router.pushPrintViewer(text: textViewer.getText(), font: textViewer.getFont())
        }
    }
    
    /// закрывает приложение
    private func exitFromApp(){
        exit(0)
    }
}

//MARK: - MenuControllerDelegate
extension TextController: MenuControllerDelegate {
    
    func menuController(_ menuController: MenuController, didPressMenu menu: MenuOptions) {
        switch menu {
        case .new:
            router.initialViewController(fileUrl: nil)
        case .open:
            router.pushDocumentViewer()
        case .save:
            save()
        case .saveAs:
            saveAs()
        case .print:
            printText()
        case .info:
            router.pushInformationViewController()
        case .exit:
            exitFromApp()
        }
    }
}

extension TextController: UITextFieldDelegate {
    
    /// проверяет поле ввода названия файла на английский алфавит
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        var result = true
        
        for charScalar in string.unicodeScalars {
            if !CharacterSet.fileNameCharacterSet.contains(charScalar) {
                result = false
                break
            }
        }
        return result
    }
}
