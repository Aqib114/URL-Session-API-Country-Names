import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!

    func configure(with city: String) {
        cityLabel.text = city
    }
}

