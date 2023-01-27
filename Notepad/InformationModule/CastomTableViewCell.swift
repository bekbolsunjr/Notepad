import UIKit
class CastomTableViewCell: UITableViewCell {
    lazy var backView: UIView = {
        //et view = UIView(frame: CGRect(x: 10, y: 6, width: self.frame.width - 20, height: 110))
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var userLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .left
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    override func layoutSubviews() {
        setupLayouts()
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        backView.layer.cornerRadius = 5
        backView.clipsToBounds = true
        userImage.layer.cornerRadius = 30
        userImage.clipsToBounds = true
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(userImage)
        backView.addSubview(userLabel)
        
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20),
            backView.topAnchor.constraint(equalTo: topAnchor),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backView.widthAnchor.constraint(equalToConstant: 250),
            backView.heightAnchor.constraint(equalToConstant: 70),
            userImage.topAnchor.constraint(equalTo: backView.topAnchor,constant: 10),
            userImage.leadingAnchor.constraint(equalTo: backView.leadingAnchor,constant: 10),
            userImage.heightAnchor.constraint(equalToConstant: 60),
            userImage.widthAnchor.constraint(equalToConstant: 60),
            userImage.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
            userLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor,constant: 10),
            userLabel.topAnchor.constraint(equalTo: backView.topAnchor,constant: 10),
            userLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor,constant: 20),
            userLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor,constant: 10)
        ])
    }

}
