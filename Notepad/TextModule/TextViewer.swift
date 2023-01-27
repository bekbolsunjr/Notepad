import UIKit

class TextViewer: UIViewController {
    
    //MARK: - Properties
    private(set) var textController: TextController?
    
    private var urlFile: URL
    private var isDate: Bool
    
    let textView: UITextView
    private let notePadToolBar: NotePadToolBar
    private let notepadView: UIImageView
    let stackView: UIStackView
    let searchAndReplaceView: SearchAndReplaceView
    let searchAndReplaceButtonView: SearchAndReplaceButtonsView
    
    private var textViewBottomConstraint: NSLayoutConstraint?
    private var stackViewBottomConstraint: NSLayoutConstraint?
    
    var ranges: [NSRange] {
        didSet {
            let isEnabled = !ranges.isEmpty
            searchAndReplaceButtonView.backButton.isEnabled = isEnabled
            searchAndReplaceButtonView.nextButton.isEnabled = isEnabled
            searchAndReplaceButtonView.replaceButton.isEnabled = isEnabled
            searchAndReplaceButtonView.replaceAllButton.isEnabled = isEnabled
        }
    }
    var selectedRangeIndex: Int
    
    var mode: Mode = .default {
        didSet {
            switch mode {
            case .default:
                searchAndReplaceView.isHidden = true
                searchAndReplaceButtonView.isHidden = true
                navigationController?.setNavigationBarHidden(false, animated: true)
                notepadView.isHidden = false
                ranges = []
                updateHighlighting()
            case .searchAndReplace:
                searchAndReplaceView.isHidden = false
                searchAndReplaceButtonView.isHidden = false
                navigationController?.setNavigationBarHidden(true, animated: true)
                notepadView.isHidden = true
                textView.resignFirstResponder()
            }
        }
    }
    //MARK: - Initialize
    init() {
        notepadView = UIImageView(image: UIImage(named: "notepad"))
        stackView = UIStackView()
        textView = UITextView()
        notePadToolBar = NotePadToolBar(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
        searchAndReplaceView = SearchAndReplaceView()
        searchAndReplaceButtonView = SearchAndReplaceButtonsView()
        urlFile = URL(fileURLWithPath: "")
        ranges = []
        selectedRangeIndex = 0
        isDate = false
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        mode = .default
    }
    
    //MARK: - SetupMethods
    private func setupViews() {
        setupImageView()
        setupStackView()
        setupTextView()
        setupSearchAndReplaceView()
        setupSearchAndReplaceButtonView()
        setupDismissKeyboardGesture()
        setupKeyboardFrame()
        setupNavigationItem()
    }
    /// настройка картинки в верху экрана
    private func setupImageView() {
        let safeArea = view.safeAreaLayoutGuide
        
        notepadView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(notepadView)
        NSLayoutConstraint.activate([
            notepadView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            notepadView.heightAnchor.constraint(equalToConstant: 18),
            notepadView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 0),
            notepadView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 0)
        ])
    }
    /// настройка Стэк Вью в котором находится все элементы TextViewer
    private func setupStackView() {
        let safeArea = view.safeAreaLayoutGuide
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackViewBottomConstraint = view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0)
        stackViewBottomConstraint?.priority = .defaultHigh
        let requiredBottomConstraint = safeArea.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor)
        
        guard let stackViewBottomConstraint = stackViewBottomConstraint else { return }
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: notepadView.bottomAnchor, constant: 0),
            stackViewBottomConstraint,
            stackView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 5),
            stackView.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -5),
            requiredBottomConstraint
        ])
        
        stackView.axis = .vertical
    }
    /// настройка TextView
    private func setupTextView() {
        textView.delegate = self
        
        textView.backgroundColor = .white
        textView.textColor = .black
       
        stackView.addArrangedSubview(textView)
        
        notePadToolBar.translatesAutoresizingMaskIntoConstraints = false
        textView.inputAccessoryView = notePadToolBar
        notePadToolBar.setNotePadToolbarDelegate(self)
        textView.font = notePadToolBar.getFont()
        notePadToolBar.setSelectedRow()
        textView.minimumZoomScale = 0.5
        textView.maximumZoomScale = 2.0
    }
    /// настройка жеста для скрытия клавиатуры
    private func setupDismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc private func viewTapped(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    /// настойка слушателя фрэйма клавиатуры
    private func setupKeyboardFrame() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    ///настройка navigation item
    func setupNavigationItem() {
        let undo = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.backward.circle"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(undoDidTap))
        
        let redo = UIBarButtonItem(image: UIImage(systemName: "arrow.uturn.forward.circle"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(redoDidTap))
        
        navigationItem.leftBarButtonItems = [undo, redo]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(menuButtonTapped))
    }
    
    //MARK: - Methods
    /// добавляет время и дату в файле
    func dateAndTime() {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        updateDateAndTime(text:" \n    \n    \(year)/\(month)/\(day) - \(hour):\(minute)")
    }
    
    /// обновляет шрифт
    func updateTextViewFont(font: UIFont) {
        textView.font = font
    }
    ///выбирает весь текст
    func selectWholeText() {
        textView.selectAll(self)
    }
    /// вырезает выбранный текст
    func cutSelectedText(text: String) {
        textView.cut(text)
        textController?.careTakerSave()
    }
    /// вставляет текст
    func pasteCopiedText(text: String) {
        textView.paste(text)
        textController?.careTakerSave()
    }
    
    func setTextController(_ textController: TextController) {
        self.textController = textController
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if let range = textView.selectedTextRange {
            notePadToolBar.setSelectedText(textView.text(in: range) ?? "")
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    /// обновляет TextView
    public func updateTextView(text: String) {
        textView.text = text
    }
    /// обновляет время и дату
    public func updateDateAndTime(text: String) {
        if !isDate {
            textView.text += text
            isDate = true
        } else {
            textView.text.removeLast(text.count)
            isDate = false
        }
        textController?.careTakerSave()
    }
    
    /// получает текст из textVIew
    public func getText() -> String {
        return textView.text
    }
    /// получает текущий шрифт
    public func getFont() -> UIFont {
        if let font = textView.font {
            return font
        }
        return UIFont()
    }
    /// обновляет тайтл в файле
    public func updateTitle(fileTitle: String) {
        title = fileTitle
    }
    /// при нажатии на кнопку меню открывает меню
    @objc func menuButtonTapped(_ sender: UIBarButtonItem) {
        textController?.showMenu(barButtonItem: sender)
    }
}

extension TextViewer {
    // MARK: - Keyboard
    @objc private func keyboardWillChangeFrame(sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let intersection = view.frame.intersection(keyboardFrame.cgRectValue)
        stackViewBottomConstraint?.constant = intersection.height
        view.layoutIfNeeded()
    }
    
    @objc func undoDidTap() {
        textController?.undoDidTap()
    }
    
    @objc func redoDidTap() {
        textController?.redoDidTap()
    }
}
