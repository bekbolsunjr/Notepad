import UIKit

class NotePadToolBar: UIToolbar {
    //MARK: Toolbar's properties
    private let flexibleSpace: UIBarButtonItem
    private var tempToolBarItems: [UIBarButtonItem]
    private var goToRight: Bool
    private var selectedText: String
    private var pasteboard: UIPasteboard
    private var fontData: FontData
    weak var notePadToolbarDelegate: NotePadToolbarDelegate?
    
    //MARK: - Initialisers
    override init(frame: CGRect) {
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        goToRight = false
        tempToolBarItems = []
        selectedText = ""
        pasteboard = UIPasteboard.general
        fontData = FontData()
        super.init(frame: frame)
        setupToolBar()
    }
    
    required init?(coder: NSCoder) {
        flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        goToRight = false
        tempToolBarItems = []
        selectedText = ""
        pasteboard = UIPasteboard.general
        fontData = FontData()
        super.init(coder: coder)
        setupToolBar()
    }
    
    func setupToolBar() {
        changeStateOfToolbar()
        sizeToFit()
        setItems(tempToolBarItems, animated: false)
        fontData.setFontPickerDelegate(delegate: self)
        fontData.setFontSizeDataSource(dataSource: self)
        fontData.setFontSizeDelegate(delegate: self)
    }
    
//    MARK: Getters and setters
    func getFont() -> UIFont {
        return fontData.getFontValue()
    }
    
    func setNotePadToolbarDelegate(_ delegate: NotePadToolbarDelegate) {
        self.notePadToolbarDelegate = delegate
    }
    
    func setSelectedText(_ text: String?) {
        selectedText = text!
    }
    
    func setSelectedRow() {
        fontData.setSelectedRow()
    }
    
//    MARK: public methods
    func changeStateOfToolbar() {
        tempToolBarItems.removeAll()
        
        if !goToRight {
            let fontSize = UIBarButtonItem(image: UIImage(systemName: "textformat.size"), style: .plain, target: self, action: #selector(setFontSize))
            let fontStyle = UIBarButtonItem(image: UIImage(systemName: "signature"), style: .plain, target: self, action: #selector(setFont))
            let selectAll = UIBarButtonItem(image: UIImage(systemName: "rectangle.fill.badge.checkmark"), style: .plain, target: self, action: #selector(selectWholeText))
            let find = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(tappedFindButton))
            let copy = UIBarButtonItem(image: UIImage(systemName: "doc.on.doc"), style: .plain, target: self, action: #selector(copyTapped))
            let paste = UIBarButtonItem(image: UIImage(systemName: "doc.on.clipboard"), style: .plain, target: self, action: #selector(pasteTapped))
            let rightArrow = UIBarButtonItem(image: UIImage(systemName: "arrow.right.to.line"), style: .plain, target: self, action: #selector(rightArrowTapped))
            
            [fontSize, flexibleSpace, fontStyle, flexibleSpace, selectAll, flexibleSpace, find, flexibleSpace, copy, flexibleSpace, paste, flexibleSpace, rightArrow].forEach { tempToolBarItems.append($0) }
        } else {
            let leftArrow = UIBarButtonItem(image: UIImage(systemName: "arrow.left.to.line"), style: .plain, target: self, action: #selector(leftArrowTapped))
            let replace = UIBarButtonItem(image: UIImage(systemName: "repeat.circle"), style: .plain, target: self, action: #selector(tappedReplaceButton))
            let goTo = UIBarButtonItem(image: UIImage(systemName: "arrow.forward"), style: .plain, target: self, action: #selector(tappedGoToButton))
            let timeAndDate = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(dateAndTime))
            let remove = UIBarButtonItem(image: UIImage(systemName: "trash.slash.circle"), style: .plain, target: self, action: #selector(removeTapped))
            let cut = UIBarButtonItem(image: UIImage(systemName: "scissors"), style: .plain, target: self, action: #selector(cutTapped))
            
            [leftArrow, flexibleSpace, replace, flexibleSpace, goTo, flexibleSpace, remove, flexibleSpace, cut, flexibleSpace, timeAndDate].forEach { tempToolBarItems.append($0) }
        }
    }
    
    @objc func removeTapped() {
        notePadToolbarDelegate?.removeSelectedTextDalegate(text: selectedText)
    }
    
    @objc func dateAndTime() {
        notePadToolbarDelegate?.dateAndTimeDeligate()
    }
    
    @objc func selectWholeText() {
        notePadToolbarDelegate?.selectWholeTextDelegate()
    }
    
    @objc func setFont() {
        let fontPicker = fontData.getFontPicker()
        notePadToolbarDelegate?.presentFontPicker(fontPicker: fontPicker)
    }
    
    @objc func setFontSize() {
        let alert = UIAlertController(title: "Select size", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.view.addSubview(fontData.getFontSizePicker())
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

            self.notePadToolbarDelegate?.updateFont(font: self.fontData.getFontValue())

        }))
        
        notePadToolbarDelegate?.presentAlert(alert: alert)
    }
    
    @objc func copyTapped(_ sender: UIButton) {
        pasteboard.string = selectedText
    }
    
    @objc func pasteTapped(_ sender: UIButton) {
        if let text = pasteboard.string {
            notePadToolbarDelegate?.pasteCopiedTextDelegate(text: text)
        }
    }
    
    @objc func rightArrowTapped(_ sender: UIButton) {
        goToRight = !goToRight
        changeStateOfToolbar()
        self.setItems(tempToolBarItems, animated: true)
    }
    
    @objc func cutTapped(_ sender: UIButton) {
        notePadToolbarDelegate?.cutSelectedTextDelegate(text: selectedText)
    }
    
    @objc func leftArrowTapped(_ sender: UIButton) {
        goToRight = !goToRight
        changeStateOfToolbar()
        self.setItems(tempToolBarItems, animated: true)
    }
    
    @objc func tappedGoToButton() {
        notePadToolbarDelegate?.didTapGoToButtonInNotePadToolBar(self)
    }
    
    @objc func tappedFindButton() {
        notePadToolbarDelegate?.didTapFindButtonInNotePadToolBar(self)
    }
    
    @objc func tappedReplaceButton() {
        notePadToolbarDelegate?.didTapReplaceButtonInNotePadToolBar(self)
    }
}

protocol NotePadToolbarDelegate: AnyObject {
    func updateFont(font: UIFont)
    
    func presentAlert(alert: UIAlertController)
    
    func presentFontPicker(fontPicker: UIFontPickerViewController)
    
    func selectWholeTextDelegate()
    
    func cutSelectedTextDelegate(text: String)
    
    func pasteCopiedTextDelegate(text: String)
    
    func dateAndTimeDeligate()
    
    func removeSelectedTextDalegate(text: String)
    
    func didTapGoToButtonInNotePadToolBar(_ notePadToolBar: NotePadToolBar)
    
    func didTapFindButtonInNotePadToolBar(_ notePadToolBar: NotePadToolBar)
    
    func didTapReplaceButtonInNotePadToolBar(_ notePadToolBar: NotePadToolBar)
}

extension NotePadToolBar: UIFontPickerViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //    PICKER VIEW PROTOCOL STUBS
        
        func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
            viewController.dismiss(animated: true, completion: nil)
        }

        func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
            viewController.dismiss(animated: true, completion: nil)
            guard let descriptor = viewController.selectedFontDescriptor else {return}
            let selectedFont = UIFont(descriptor: descriptor, size: fontData.getFontSize())
            
            fontData.setCurrentFontValue(selectedFont)
            notePadToolbarDelegate?.updateFont(font: selectedFont)
        }
    
    
//    ALERT WITH PICKER VIEW PROTOCOL STUBS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let fontSizes = fontData.getFontSizes()
        return fontSizes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let fontSizes = fontData.getFontSizes()
        return String(fontSizes[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fontData.setCurrentFontValue(UIFont(name: fontData.getFontValue().fontName, size: CGFloat(fontData.getFontSizes()[row]))!)
    }
}
