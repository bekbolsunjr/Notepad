import UIKit

class InformationViewController: UIViewController {
    private let usersArray: [UserModel]
    private var mainTableView: UITableView
    private let identifer = "TableViewCell"
    //MARK: Initialiations
    init() {
        usersArray = UserModel().getArrayUsers()
        self.mainTableView = UITableView()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: --------------------------------------------override--------------------------------------
        override func viewDidLoad() {
        super.viewDidLoad()
        creatTable()
    }
    // setup table
    func creatTable() {
        mainTableView.frame = self.view.frame
        self.mainTableView = UITableView(frame: view.bounds, style: .plain)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.navigationItem.title = "Команда разработки"
        mainTableView.separatorColor = UIColor.clear
        mainTableView.backgroundColor = UIColor.white
        mainTableView.register(CastomTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        view.addSubview(mainTableView)
    }
    
    
}
extension InformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.mainTableView:
            return self.usersArray.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as?
            CastomTableViewCell else {fatalError("unabel to crate cell")}
        cell.userImage.image = usersArray[indexPath.row].getUserImage()
        cell.userLabel.text = usersArray[indexPath.row].getUserLabel()
        return cell
      }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
