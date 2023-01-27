import Foundation

class FileManagerModel {
    //создаем файл менеджер
    let filemanager = FileManager.default
    // открытие файла и чтение пути через LineReader
    func openFile(_ fileUrl: URL) -> String {
        let lineReader = LineReader(path: fileUrl.path)
        return lineReader.read() ?? ""
    }
    // чтение пути через readFileByCharacter
    func readFileByCharacter(_ fileUrl: URL) -> String {
        do {
            return try (CharacterReader(fileUrl: fileUrl).read())!
        } catch {
            return ""
        }
    }
// создает дефолтный путь для сохранение файла без расширение
    func generateFileUrl(fileName: String) -> URL {
        var url = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        if url.pathExtension.isEmpty {
            url.appendPathExtension("ntp")
        }
        return url
    }
// сохранениe файла через filemanager
    func save(fileUrl: URL, content: String) {
        filemanager.createFile(atPath: fileUrl.path, contents: content.data(using: .utf8))
    }
    // получаем список всех файлов в директории Documents
    func filelist() -> [String] {
        let files: String = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        let list: [String] = try! filemanager.contentsOfDirectory(atPath: files)
        return list
    }
    // получаем список всех путей в директории Documents
    func getPaths() -> [String: String] {
        let folderDocument: String = filemanager.urls(for: .documentDirectory,
                                              in: .userDomainMask)[0].path
        var listWithUrl: [String: String] = [:]
        do {
            let list = try? filemanager.contentsOfDirectory(atPath: folderDocument)
            guard let list = list else { return [String: String]() }
            for file in list {
                let key = folderDocument + "/" + file
                listWithUrl[key] = file
            }
        }
        return listWithUrl
    }
    // получаем расширение файла из пути
    func getPathExt(urlPath: String) -> String {
        let url: URL? = URL(string: urlPath)
        let name: String? = url?.pathExtension
        return name ?? "ntp"
    }
    // получаем размер файла
    func getFileSize(at path: String) -> Int? {
        let attributes = try? filemanager.attributesOfItem(atPath: path)
        let fileSize: Int? = attributes?[.size] as? Int
        return fileSize
    }
    // проверка на то что существует ли файл
    func fileExists(_ fileUrl: URL) -> Bool {
        return filemanager.fileExists(atPath: fileUrl.path)
    }
}
