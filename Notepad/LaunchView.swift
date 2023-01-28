import UIKit

class LaunchView: UIView {
    
    private let foldersView: UIImageView
    private let pointsView: UIImageView


    override init(frame: CGRect) {
        foldersView = UIImageView()
        foldersView.alpha = 0

        pointsView = UIImageView()
        
        super.init(frame: frame)
        backgroundColor = .red
        uiConfig()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func uiConfig(){
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

        addSubview(foldersView)
        addSubview(pointsView)

        foldersView.image = UIImage(named: "logo")
        pointsView.image = UIImage(named: "points")

        setupConstraints()
        appearAnimation()
    }
    
    private func resizeImageView() {
        if let widthPoints = pointsView.image?.size.width,
           let heightPoints = pointsView.image?.size.height {
            
            pointsView.heightAnchor.constraint(equalToConstant: heightPoints * 0.09).isActive = true
            pointsView.widthAnchor.constraint(equalToConstant: widthPoints * 0.09).isActive = true
        }
    }
    
    private func setupConstraints() {
        resizeImageView()
        
        foldersView.translatesAutoresizingMaskIntoConstraints = false
        pointsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([

            foldersView.centerYAnchor.constraint(equalTo: centerYAnchor),
            foldersView.centerXAnchor.constraint(equalTo: centerXAnchor),
            foldersView.heightAnchor.constraint(equalToConstant: 334),
            foldersView.widthAnchor.constraint(equalToConstant: 228.7),
            
            pointsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -35),
            pointsView.centerXAnchor.constraint(equalTo: centerXAnchor)
            
        ])
    }
    
    private func appearAnimation() {
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.foldersView.alpha = 1
        } completion: { [weak self] _ in
            self?.disappearLaunchView()
        }
    }

    private func disappearLaunchView() {
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.foldersView.alpha = 0
            self?.pointsView.alpha = 0
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
}
