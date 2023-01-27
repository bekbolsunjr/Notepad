import UIKit

extension TextViewer: NotePadToolbarDelegate {
    
    // MARK: Public methods from protocol
    func updateFont(font: UIFont) {
        updateTextViewFont(font: font)
        textController?.careTakerSave()
    }

    func presentAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func presentFontPicker(fontPicker: UIFontPickerViewController) {
        present(fontPicker, animated: true)
    }
    
    func selectWholeTextDelegate() {
        selectWholeText()
    }

    func cutSelectedTextDelegate(text: String) {
        cutSelectedText(text: text)
    }
    
    func pasteCopiedTextDelegate(text: String) {
        pasteCopiedText(text: text)
    }
    
    func dateAndTimeDeligate() {
        dateAndTime()
    }
    
    func removeSelectedTextDalegate(text: String) {
        let updatedText = (getText() as NSString).replacingCharacters(in: textView.selectedRange, with: "")
        updateTextView(text: updatedText)
    }
    
    func didTapGoToButtonInNotePadToolBar(_ notePadToolBar: NotePadToolBar) {
        textController?.openAnotherDocument()
    }
    
    func didTapFindButtonInNotePadToolBar(_ notePadToolBar: NotePadToolBar) {
        searchAndReplaceView.isReplacingEnabled = false
        searchAndReplaceButtonView.isReplacingEnabled = false
        mode = .searchAndReplace
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func didTapReplaceButtonInNotePadToolBar(_ notePadToolBar: NotePadToolBar) {
        searchAndReplaceView.isReplacingEnabled = true
        searchAndReplaceButtonView.isReplacingEnabled = true
        mode = .searchAndReplace
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - Add undo and redo command
extension TextViewer: TextWriterProtocol {
    func saveState() -> TextMemento {
        TextMemento(text: getText(),
                    textFont: getFont())
    }
    
    func restore(state: TextMemento) {
        updateTextView(text: state.getText())
        updateTextViewFont(font: state.getFont())
    }
}

extension TextViewer: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == " " {
            textController?.careTakerSave()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        mode = .default
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textController?.careTakerSave()
    }
}
