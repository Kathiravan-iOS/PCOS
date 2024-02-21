import UIKit

class MeditationHomeVC: UIViewController {
    @IBOutlet weak var sleep: UIImageView!
    
    @IBOutlet weak var stress: UIImageView!
    
    @IBOutlet weak var personal_growth: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Adding tap gesture recognizer to the sleep UIImageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sleepImageTapped))
        sleep.isUserInteractionEnabled = true
        sleep.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(growthImageTapped))
        personal_growth.isUserInteractionEnabled = true
        personal_growth.addGestureRecognizer(tapGesture1)
    }
    
    @objc func sleepImageTapped() {
        if let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BetterSleepVC") as? BetterSleepVC {
            welcomeVC.medname = "better sleep"
            welcomeVC.meditationImage = sleep.image // Pass the image here
            navigationController?.pushViewController(welcomeVC, animated: true)
        }
    }
    @objc func growthImageTapped(){
        if let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BetterSleepVC") as? BetterSleepVC {
            welcomeVC.medname = "Personal growth"
            welcomeVC.meditationImage = personal_growth.image // Pass the image here
            navigationController?.pushViewController(welcomeVC, animated: true)
            
        }
    }
}
