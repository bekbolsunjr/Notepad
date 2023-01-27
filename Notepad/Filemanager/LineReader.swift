import Foundation

class LineReader {
    
    private let path: String
    
    init(path: String) {
        self.path = path
    }
    /// читает файл и возвращает строку
    /// - Returns: возвращает содержимое файла в виде строки или nil
    func read() -> String? {
        // fopen открывает файл с правами чтения (r)
        guard let file = fopen(path, "r") else {
            return nil
        }
        // закрывает файл после выхода из функции
        defer {
            fclose(file)
        }
        // указатель на прочтенную строку
        var buffer: UnsafeMutablePointer<CChar>?
        // размер буфера
        var bufferSize = 0
        // результирующая строка, которая собирает в себя строки из файла
        var lines = [String]()
        
        // читает в цикле построчно в буфер, когда getline вернет 0 выходим из цикла
        while getline(&buffer, &bufferSize, file) > 0 {
            if let buffer = buffer {
                lines.append(String(cString: buffer))
            }
            // освобождает буфер и обнуляет переменные
            free(buffer)
            buffer = nil
            bufferSize = 0
        }
        return lines.joined()
    }
}
