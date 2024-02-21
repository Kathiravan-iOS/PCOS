import UIKit

class StartHomeVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let imageView = image else {
            print("imageView outlet is not connected.")
            return
        }

        if let frame1 = UIImage(named: "K2"),
           let frame3 = UIImage(named: "S3")
        {
            imageView.animationImages = [frame1, frame3]
            imageView.animationDuration = 2.0
            imageView.animationRepeatCount = 0
            imageView.startAnimating()

            // Use a delay to wait for the animation to complete
            DispatchQueue.main.asyncAfter(deadline: .now() + imageView.animationDuration) {
                self.navigateToRecordDailyProgressVC()
            }
        } else {
            print("Error: One or more images not found.")
        }
    }

    func navigateToRecordDailyProgressVC() {
        let recorddailyprogreeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "recorddailyprogreeVC") as! recorddailyprogreeVC
        navigationController?.pushViewController(recorddailyprogreeVC, animated: true)
    }
}
