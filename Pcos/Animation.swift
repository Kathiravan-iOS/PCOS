import UIKit

class Animation: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let imageView = imageView else {
            print("imageView outlet is not connected.")
            return
        }

        if let frame1 = UIImage(named: "A1"),
           let frame2 = UIImage(named: "A5"),
           let frame3 = UIImage(named: "A6"),
           let frame4 = UIImage(named: "A7")
        {
            imageView.animationImages = [frame1, frame2, frame3, frame4]
            imageView.animationDuration = 5.0
            imageView.animationRepeatCount = 0
            imageView.startAnimating()
        } else {
            print("Error: One or more images not found.")
        }
    }
}
