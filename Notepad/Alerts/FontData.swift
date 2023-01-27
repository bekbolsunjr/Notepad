import UIKit

class FontData: NSObject {
    
    // MARK: Properties
    private let fontSizes: Array<Int>
    private var fontValue: UIFont
    private let fontPicker: UIFontPickerViewController
    private let fontSizePicker: UIPickerView
    private let defaultSize: Int
    
    // MARK: Initializer
    override init() {
        fontSizes = Array(10...47)
        defaultSize = 14
        fontValue = UIFont(name: "Arial", size: CGFloat(defaultSize))!
        
        let config = UIFontPickerViewController.Configuration()
        config.includeFaces = true
        fontPicker = UIFontPickerViewController(configuration: config)
        
        fontSizePicker = UIPickerView(frame: CGRect(x: 5, y: 30, width: 250, height: 140))
    }
    
    // MARK: Getters and setters
    func getFontSizes() -> Array<Int> {
        return fontSizes
    }
    
    func getFontValue() -> UIFont {
        return fontValue
    }
    
    func setCurrentFontValue(_ font: UIFont) {
        fontValue = font
    }
    
    func getFontSize() -> CGFloat {
        return fontValue.pointSize
    }
    
    func getFontPicker() -> UIFontPickerViewController {
        return fontPicker
    }
    
    func setFontPickerDelegate(delegate: UIFontPickerViewControllerDelegate) {
        fontPicker.delegate = delegate
    }
    
    func setFontSizeDataSource(dataSource: UIPickerViewDataSource) {
        fontSizePicker.dataSource = dataSource
    }
    
    func setFontSizeDelegate(delegate: UIPickerViewDelegate) {
        fontSizePicker.delegate = delegate
    }
    
    func getFontSizePicker() -> UIPickerView {
        return fontSizePicker
    }
    
    func setSelectedRow() {
        guard let index = fontSizes.firstIndex(of: defaultSize) else {return}
        fontSizePicker.selectRow(index, inComponent: 0, animated: false)
    }
}
