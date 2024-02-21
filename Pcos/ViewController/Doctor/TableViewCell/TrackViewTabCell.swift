import UIKit

protocol TrackViewTabCellDelegate: AnyObject {
    func didSelectCategory()
    func didSelectAssessment()
    // Add more methods for other actions if needed
}

class TrackViewTabCell: UITableViewCell {

    @IBOutlet weak var assessment: UIButton?
    @IBOutlet weak var viewPatientCat: UIButton?

    weak var delegate: TrackViewTabCellDelegate?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            if let delegate = delegate {
                if let viewPatientCat = viewPatientCat, viewPatientCat.isTouchInside {
                    delegate.didSelectCategory()
                }
                if let assessment = assessment, assessment.isTouchInside {
                    delegate.didSelectAssessment()
                }
            }
        }
    }
}
