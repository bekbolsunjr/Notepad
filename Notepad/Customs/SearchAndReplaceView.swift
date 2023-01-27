import UIKit

class SearchAndReplaceView: UIView {
    
//    MARK: Properties
    private let horizontalStackView: UIStackView
    private let verticalStackView: UIStackView
    private let searchTextField: UITextField
    private let replaceTextField: UITextField
    private let doneButton: UIButton
    var isReplacingEnabled: Bool {
        get {
            return !replaceTextField.isHidden
        }
        set {
            replaceTextField.isHidden = !newValue
        }
    }
    
//    MARK: Initializers
    override init(frame: CGRect) {
        horizontalStackView = UIStackView()
        verticalStackView = UIStackView()
        searchTextField = UITextField()
        replaceTextField = UITextField()
        doneButton = UIButton(type: .close)
        super.init(frame: frame)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 12
        horizontalStackView.alignment = .top
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalStackView)
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            horizontalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            horizontalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        ])
        horizontalStackView.addArrangedSubview(verticalStackView)
        horizontalStackView.addArrangedSubview(doneButton)
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 12
        verticalStackView.addArrangedSubview(searchTextField)
        verticalStackView.addArrangedSubview(replaceTextField)
        
        searchTextField.returnKeyType = .search
        searchTextField.borderStyle = .roundedRect
        searchTextField.placeholder = "Find"
        replaceTextField.borderStyle = .roundedRect
        replaceTextField.returnKeyType = .search
        replaceTextField.placeholder = "Replace"
        doneButton.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Getters and setters
    func getSearchTextField() -> UITextField {
        return searchTextField
    }
    
    func getReplaceTextField() -> UITextField {
        return replaceTextField
    }
    
    func getTextSearchTextField() -> String? {
        return searchTextField.text
    }
    
    func getTextReplaceTextField() -> String? {
        return replaceTextField.text
    }
    
    func setSearchTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        searchTextField.delegate = delegate
    }
    
    func setReplaceTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        replaceTextField.delegate = delegate
    }
    
    func setTargetToDoneButton(_ target: TextViewer, _ action: Selector, _ activator: UIControl.Event) {
        doneButton.addTarget(target, action: action, for: activator)
    }
}
