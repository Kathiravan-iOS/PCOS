import UIKit

class CalendarCell: UITableViewCell {
    var usernameForCalendar: String?

    @IBOutlet weak var calenderimage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!  // Add this line if not already defined

    override func awakeFromNib() {
        super.awakeFromNib()
        addTapGesture()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(withTitle title: String) {
        titleLabel.text = title
    }

    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        calenderimage.isUserInteractionEnabled = true
        calenderimage.addGestureRecognizer(tapGesture)
    }

    @objc func cellTapped() {
        if #available(iOS 16.0, *) {
            let calendarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
            // Pass the username to CalendarVC
            calendarVC.usernameForCalendar = self.usernameForCalendar ?? ""

            // Assuming your CalendarCell is part of a view controller, you need to get the navigation controller from the view hierarchy
            if let navigationController = self.window?.rootViewController as? UINavigationController {
                navigationController.pushViewController(calendarVC, animated: true)
            }
        }
    }
}
