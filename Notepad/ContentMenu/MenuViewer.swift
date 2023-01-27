import UIKit

class MenuViewer: UIViewController {
    
    //MARK: - Properties
    private let tableView: UITableView
    private let menuController: MenuController
    
    //MARK: - Initialisers
    init(menuController: MenuController) {
        tableView = UITableView()
        self.menuController = menuController
        
        super.init(nibName: nil, bundle: nil)

        tableView.backgroundColor = nil
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.preferredContentSize = CGSize(
            width: UIScreen.main.bounds.width * 0.6,
            height: CGFloat(MenuOptions.allCases.count) * 44)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .gray
        tableView.rowHeight = 44
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: view.bounds.size.height)

    }
}
    //MARK: - TableView

extension MenuViewer: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuController.numberOfMenus()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MenuTableViewCell
        cell?.textLabel?.text = menuController.menuTitle(at: indexPath.row)
        cell?.imageView?.image = menuController.menuImage(at: indexPath.row)
        return cell!
    }
}

extension MenuViewer: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.menuController.menuTapped(at: indexPath.row, in: self)
    }
}

