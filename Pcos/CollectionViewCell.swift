import UIKit

class MedicalRecordCell: UICollectionViewCell {
    @IBOutlet weak var report: UIImageView!

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
                // Adjust contentMode as needed, .scaleAspectFill or .scaleAspectFit
                self?.report.contentMode = .scaleAspectFit
            }
        }.resume()
    }
}
