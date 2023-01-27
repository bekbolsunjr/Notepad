import Foundation

extension CharacterSet {
    
    static let fileNameCharacterSet = CharacterSet(
        charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        .union(.decimalDigits)
        .union(.punctuationCharacters)
}
