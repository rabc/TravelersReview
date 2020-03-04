import UIKit
import AppServices



class ListTableViewCell: UITableViewCell, ReusableCell, NibLoadable {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    func setup(with review: Review) {
        dateLabel.text = DateFormatCacheManager.shared.shortDateStyle.string(from: review.created)
        reviewTextLabel.text = review.message
        authorNameLabel.text = review.author.fullName
        
        if let country = review.author.country {
            authorNameLabel.text = "\(authorNameLabel.text ?? "") (\(country))"
        }
        
        switch review.travelerType {
        case .couple:
            iconImageView.image = UIImage.iconCouple
        case .solo:
            iconImageView.image = UIImage.iconSolo
        case .friends:
            iconImageView.image = UIImage.iconFriends
        case .oldFamily, .youngFamily:
            iconImageView.image = UIImage.iconFamily
        default:
            iconImageView.isHidden = true
        }
    }
}
