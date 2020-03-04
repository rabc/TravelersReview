import UIKit

extension UIAlertController {
    class func singleButtonAlert(message: String, title: String = "Alert",
                                 buttonTitle: String = "OK", defaultAction: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: buttonTitle, style: .default) { (action) in
            defaultAction?()
        }
        
        alertController.addAction(OKAction)
        
        return alertController
    }
}
