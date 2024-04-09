import UIKit

protocol TrackViewTabCellDelegate: AnyObject {
    func didSelectCategory(cell: TrackViewTabCell)
    func didSelectAssessment(cell: TrackViewTabCell)
}

class TrackViewTabCell: UITableViewCell {
    
    @IBOutlet weak var assessmentButton: UIButton?
    @IBOutlet weak var viewPatientCatButton: UIButton?
    
    
    weak var delegate: TrackViewTabCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        updateButtonTextBasedOnUserRole()

    }
    private func updateButtonTextBasedOnUserRole() {
        if UserDefaultsManager.shared.getUserName() == "Doctor" {
                assessmentButton?.setTitle("Analysed Patient Category", for: .normal)
            } else {
                assessmentButton?.setTitle("Assessment", for: .normal)
            }
        }
    
}
