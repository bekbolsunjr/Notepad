import UIKit

class DocumentCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    private var fileTypeLabel: UILabel
    private var fileNameLabel: UILabel

    //MARK: - Initialize
    override init(frame: CGRect) {
        fileTypeLabel = UILabel()
        fileNameLabel = UILabel()

        fileNameLabel.clipsToBounds = true
        fileTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        setupImageView()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Methods
    private func setupImageView() {
        fileTypeLabel.textColor = #colorLiteral(red: 0.7767494321, green: 0.04680993408, blue: 0.391726166, alpha: 1)
        fileTypeLabel.textAlignment = .center
        fileTypeLabel.layer.borderWidth = 1
        fileTypeLabel.layer.backgroundColor = #colorLiteral(red: 0.9411765337, green: 0.9411764741, blue: 0.9411765337, alpha: 1)
        fileTypeLabel.layer.cornerRadius = 10
        fileTypeLabel.layer.borderColor = #colorLiteral(red: 0.5568627715, green: 0.5568627715, blue: 0.5568627715, alpha: 1)
        
        fileNameLabel.font = UIFont.systemFont(ofSize: 12)
        
        addSubview(fileTypeLabel)

        NSLayoutConstraint.activate([
            fileTypeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            fileTypeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            fileTypeLabel.heightAnchor.constraint(equalToConstant: 80),
            fileTypeLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        addSubview(fileNameLabel)

        NSLayoutConstraint.activate([
            fileNameLabel.topAnchor.constraint(equalTo: fileTypeLabel.bottomAnchor,
                                               constant: 2),
            fileNameLabel.centerXAnchor.constraint(equalTo: fileTypeLabel.centerXAnchor)
        ])
    }

    public func setDataCell(fileType: String,
                            fileName: String) {
        fileTypeLabel.text = fileType
        fileNameLabel.text = fileName
    }
}
