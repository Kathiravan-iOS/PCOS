import UIKit

class MedicalRecordCell: UICollectionViewCell {
    @IBOutlet weak var report: UIImageView!
    override func awakeFromNib() {
            super.awakeFromNib()
            setupCellAppearance()
        }
        
        func setupCellAppearance() {
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1.0
            self.layer.cornerRadius = 8.0
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4.0
            self.layer.shadowOpacity = 0.25
            self.layer.masksToBounds = false
            self.clipsToBounds = false
        }

    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Could not decode image data")
                return
            }
            
            DispatchQueue.main.async {
                self?.report.image = image
                self?.report.contentMode = .scaleAspectFit
            }
        }.resume()
        
    }
}
