import UIKit

extension UIView {
    static func loadingOverlay(frame: CGRect) -> UIView {
        let overlay = UIView(frame: frame)
        overlay.backgroundColor = UIColor.clear
        
        let middleView = UIView(frame: CGRect.zero)
        middleView.backgroundColor = UIColor.white
        middleView.layer.masksToBounds = false
        middleView.layer.cornerRadius = 10.0
        overlay.addSubview(middleView)
        
        middleView.setupSizeAnchor(width: 80.0, height: 80.0)
        middleView.centerInView(overlay)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = UIColor.gray
        activityIndicator.startAnimating()
        middleView.addSubview(activityIndicator)
        
        activityIndicator.centerInView(middleView)
        
        overlay.setNeedsUpdateConstraints()
        overlay.setNeedsLayout()
        
        return overlay
    }
}

// - MARK: Autolayout
extension UIView {
    private func activateConstraints(_ constraints: [NSLayoutConstraint]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
    
    func pinAnchors(_ attributes: [NSLayoutConstraint.Attribute], to view: UIView, constant: CGFloat = 0.0) {
        let guide = view.safeAreaLayoutGuide
        var constraints = [NSLayoutConstraint]()
        for attribute in attributes {
            switch attribute {
            case .leading:
                constraints.append(self.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: constant))
            case .bottom:
                constraints.append(self.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: constant))
            case .trailing:
                constraints.append(self.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: constant))
            case .top:
                constraints.append(self.topAnchor.constraint(equalTo: guide.topAnchor, constant: constant))
            default:
                assertionFailure("You can't pin the attribute [\(attribute.rawValue)]")
            }
        }
        
        activateConstraints(constraints)
    }
    
    func setupSizeAnchor(width: CGFloat, height: CGFloat) {
        activateConstraints([self.widthAnchor.constraint(equalToConstant: width),
                             self.heightAnchor.constraint(equalToConstant: height)])
    }
    
    func centerInView(_ view: UIView) {
        activateConstraints([self.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                             self.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
    }
}
