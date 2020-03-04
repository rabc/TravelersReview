import UIKit

extension Array {
    subscript (safe index: Int) -> Element? {
        return index >= 0 && count > index ? self[index] : nil
    }
}

extension UIImage {
    static var iconFamily: UIImage? { return UIImage(named: "icon_family") }
    static var iconCouple: UIImage? { return UIImage(named: "icon_couple") }
    static var iconFriends: UIImage? { return UIImage(named: "icon_friends") }
    static var iconSolo: UIImage? { return UIImage(named: "icon_solo") }
}
