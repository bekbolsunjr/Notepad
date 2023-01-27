import Foundation
import UIKit

extension TextViewer {
    
    /// режим textViewer
    enum Mode {
        /// режим по дефолту
        case `default`
        /// режим при поиске и замене текста
        case searchAndReplace
    }
    /// настройка view  поиска и замены
    func setupSearchAndReplaceView() {
        stackView.insertArrangedSubview(searchAndReplaceView, at: 0)
        searchAndReplaceView.setSearchTextFieldDelegate(self)
        searchAndReplaceView.setReplaceTextFieldDelegate(self)
        searchAndReplaceView.setTargetToDoneButton(self, #selector(closeSearchView), .touchUpInside)
    }
    /// настройка кнопок поиска и замены
    func setupSearchAndReplaceButtonView() {
        stackView.addArrangedSubview(searchAndReplaceButtonView)
        searchAndReplaceButtonView.backButton.addTarget(self,
                                                        action: #selector(jumpToPreviousSearch),
                                                        for: .touchUpInside)
        searchAndReplaceButtonView.nextButton.addTarget(self,
                                                        action: #selector(jumpToNextSearch),
                                                        for: .touchUpInside)
        searchAndReplaceButtonView.replaceButton.addTarget(self, action: #selector(replaceSearchText), for: .touchUpInside)
        searchAndReplaceButtonView.replaceAllButton.addTarget(self, action: #selector(replaceAllSearchText), for: .touchUpInside)
    }
    
    /// закрытие режима поиска и замены
    @objc func closeSearchView() {
        mode = .default
    }
    
    ///подсветка найденного текста
    func highlightRanges(_ ranges: [NSRange]) {
        self.ranges = ranges
        updateHighlighting()
    }
    
    /// обновление подсветки в нужных местах
    func updateHighlighting() {
        let newAttributedText = NSMutableAttributedString(string: textView.text, attributes: [.font : textView.font ?? .systemFont(ofSize: UIFont.systemFontSize)])
        ranges.enumerated().forEach { index, range in
            let color = index == selectedRangeIndex ? UIColor.green : UIColor.yellow
            newAttributedText.addAttribute(.backgroundColor, value: color, range: range)
        }
        textView.attributedText = newAttributedText
    }

    /// переход к предыдущему найденному тексту
    @objc func jumpToPreviousSearch() {
        guard !ranges.isEmpty else { return }
        selectedRangeIndex -= 1
        if selectedRangeIndex < 0 {
            selectedRangeIndex = ranges.count - 1
        }
        updateHighlighting()
        textView.scrollRangeToVisible(ranges[selectedRangeIndex])
    }
    
    /// переход к следующему найденному тексту
    @objc func jumpToNextSearch() {
        guard !ranges.isEmpty else { return }
        selectedRangeIndex += 1
        if selectedRangeIndex >= ranges.count {
            selectedRangeIndex = 0
        }
        updateHighlighting()
        textView.scrollRangeToVisible(ranges[selectedRangeIndex])
    }
    
    /// замены найденного текста
    @objc func replaceSearchText() {
        guard !ranges.isEmpty else { return }
        textController?.replace(ranges: [ranges[selectedRangeIndex]],
                                                       replaceString: searchAndReplaceView.getTextReplaceTextField() ?? "")
        textController?.search(searchAndReplaceView.getTextSearchTextField() ?? "")
        textController?.careTakerSave()
    }
    
    /// замена найденного текста полностью
    @objc func replaceAllSearchText() {
        textController?.replace(ranges: ranges, replaceString: searchAndReplaceView.getTextReplaceTextField() ?? "")
        textController?.search(searchAndReplaceView.getTextSearchTextField() ?? "")
        textController?.careTakerSave()
    }
}

extension TextViewer: UITextFieldDelegate {
    /// делегатный метод для перехвата return на клавитуре в текст филдах
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // для search replace textfield производится поиск и прокрутка до первого найденного значения
        if (textField == searchAndReplaceView.getSearchTextField() || textField == searchAndReplaceView.getReplaceTextField()),
           let text = searchAndReplaceView.getTextSearchTextField()
        {
            textController?.search(text)
            textField.resignFirstResponder()
            selectedRangeIndex = 0
            if !ranges.isEmpty {
                textView.scrollRangeToVisible(ranges[selectedRangeIndex])
            }
        }
        return true
    }
}
