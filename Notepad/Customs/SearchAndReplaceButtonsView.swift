import UIKit

class SearchAndReplaceButtonsView: UIView {
    
//    MARK: Properties
    private let horizontalStackView: UIStackView
    let backButton: UIButton
    let nextButton: UIButton
    let replaceButton: UIButton
    let replaceAllButton: UIButton
    var isReplacingEnabled: Bool {
        get {
            return !replaceButton.isHidden && !replaceAllButton.isHidden
        }
        set {
            replaceAllButton.isHidden = !newValue
            replaceButton.isHidden = !newValue
        }
    }
    
//    MARK: Initializers
    override init(frame: CGRect) {
        horizontalStackView = UIStackView()
        backButton = UIButton(type: .system)
        nextButton = UIButton(type: .system)
        replaceButton = UIButton(type: .system)
        replaceAllButton = UIButton(type: .system)
        super.init(frame: frame)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 12
        horizontalStackView.alignment = .bottom
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalStackView)
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            horizontalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            horizontalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        ])
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.addArrangedSubview(backButton)
        horizontalStackView.addArrangedSubview(replaceButton)
        horizontalStackView.addArrangedSubview(replaceAllButton)
        horizontalStackView.addArrangedSubview(nextButton)
        
        backButton.setImage(UIImage(systemName: "chevron.backward.circle"), for: .normal)
        nextButton.setImage(UIImage(systemName: "chevron.forward.circle"), for: .normal)
        replaceButton.setTitle("Replace", for: .normal)
        replaceAllButton.setTitle("Replace all", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
