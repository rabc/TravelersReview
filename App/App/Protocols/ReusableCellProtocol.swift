import UIKit

/// Every cell that needs to be reused can extend from this protocol for the setup and dequeue process
protocol ReusableCell: class {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    /// Our default is the string of the class name
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
protocol NibLoadable: class {
    static var nib: UINib { get }
    static var nibName: String { get }
}

extension NibLoadable {
    static var nibName: String {
        return String(describing: self)
    }
    
    static var bundle: Bundle {
        return Bundle(for: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: Self.nibName, bundle: Self.bundle)
    }
    
    static var nibInstance: UIView {
        return Self.nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

extension NibLoadable where Self: UIView {
    static func instantiate(removeAutoresizing: Bool = true) -> Self {
        guard let instance = Self.bundle.loadNibNamed(Self.nibName, owner: nil, options: nil)?.first as? Self else {
            assertionFailure("Loading wrong nib")
            return Self()
        }
        
        instance.translatesAutoresizingMaskIntoConstraints = !removeAutoresizing
        return instance
    }
}

extension UITableView {
    func registerNibForReuse<T: UITableViewCell>(cell: T.Type) where T: ReusableCell, T: NibLoadable {
        self.register(cell.nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
}
