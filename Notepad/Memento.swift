import UIKit

protocol TextWriterProtocol {
    func saveState() -> TextMemento
    func restore(state: TextMemento)
}

final class TextMemento {
    private let text: String
    private let textFont: UIFont
    
    init(text: String,
         textFont: UIFont) {
        self.text = text
        self.textFont = textFont
    }
    
    func getText() -> String {
        return text
    }
    
    func getFont() -> UIFont {
        return textFont
    }
}

final class CareTaker {
    private var states: [TextMemento]
    private var currentIndex: Int
    private var textWriter: TextWriterProtocol
    
    init(textWriter: TextWriterProtocol) {
        states = []
        currentIndex = 0
        self.textWriter = textWriter
    }
    
    func removeStates() {
        states.removeAll()
    }
    
    func save() {
        if states.count >= 5 {
            states.removeFirst() }
        
        states.append(textWriter.saveState())
        currentIndex = states.count - 1
    }
    
    func undo() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        
        textWriter.restore(state: states[currentIndex])
    }
    
    func redo() {
        let index = currentIndex + 1
        guard index <= states.count - 1 else { return }
        
        currentIndex = index
        
        textWriter.restore(state: states[index])
    }
}
