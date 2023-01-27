import UIKit

class DocumentController {
    //MARK: - Properties
    private let documentViewer: DocumentViewer
    private let fileManager: FileManagerModel
    private var pathDictionary: [String: String]
    private let router: RouterProtocol
    
    //MARK: - Initialize
    init(documentViewer: DocumentViewer,
         router: RouterProtocol) {
        self.documentViewer = documentViewer
        fileManager = FileManagerModel()
        pathDictionary = fileManager.getPaths()
        self.router = router
    }
    
    //MARK: - Methods
    func getCountUrls() -> Int {
        return pathDictionary.count
    }
    
    func getPath(index: Int) -> String {
        let pathArray = pathDictionary.map {$0.key}
        return pathArray[index]
    }
    
    func getFileName(index: Int) -> String {
        let nameList = pathDictionary.map {$0.value}
        return nameList[index]
    }
    
    func setTextForTextViewer(path: String) {
        guard let fileSize = fileManager.getFileSize(at: path) else { return }
        guard fileSize <= 5_629_273 else {
            let alert = UIAlertController.createFileMaxSizeErrorAlert()
            documentViewer.present(alert, animated: true)
            return
        }
        let permittedExtansions = ["ntp", "java", "swift", "kt"]
        guard permittedExtansions.contains(URL(fileURLWithPath: path).pathExtension) else {
            let alert = UIAlertController.createFileExtansionErrorAlert()
            documentViewer.present(alert, animated: true)
            return
        }
        router.initialViewController(fileUrl: URL(fileURLWithPath: path))
    }
    
    func getpathExt(path: String) -> String {
        let ext = fileManager.getPathExt(urlPath: path)
        return ext
    }
}
