import Foundation
import UIKit
class UserModel {
    private var userImage: UIImage?
    private var userLabel: String?
    
    
    convenience init(userImage: UIImage, userLabel: String) {
        self.init()
        self.userImage = userImage
        self.userLabel = userLabel
    }
    public func getArrayUsers() -> [UserModel] {
        var userArr = [UserModel]()
        userArr.append(UserModel(userImage: UIImage(named: "bek")!, userLabel: "Бекболсун Таалайбеков"))
        userArr.append(UserModel(userImage: UIImage(named: "begai")!, userLabel: "Акунова Бегайым"))
        userArr.append(UserModel(userImage: UIImage(named: "nargiza")!, userLabel: "Наргиза Бейшекенова"))
        userArr.append(UserModel(userImage: UIImage(named: "pamir")!, userLabel: "Памирбек Алмазбеков"))
        userArr.append(UserModel(userImage: UIImage(named: "sherislam")!, userLabel: "Шерислам Талатбеков"))
        userArr.append(UserModel(userImage: UIImage(named: "beks")!, userLabel: "Бексултан Маратов"))
        userArr.append(UserModel(userImage: UIImage(named: "magomed")!, userLabel: "Магомед Нагоев"))
        userArr.shuffle()
        return userArr
    }
    public func getUserImage() -> UIImage {
        return self.userImage!
    }
    
    public func  getUserLabel() -> String {
        return self.userLabel!
    }
    
}
