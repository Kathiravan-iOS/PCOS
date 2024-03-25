import UIKit

class MeditationHomeVC: UIViewController {
    @IBOutlet weak var sleep: UIImageView!
    
    @IBOutlet weak var stress: UIImageView!
    
    @IBOutlet weak var personal_growth: UIImageView!
    
    @IBOutlet weak var anxiety: UIImageView!
    
    @IBOutlet weak var increase: UIImageView!
    
    @IBOutlet weak var concentration: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        customizeNavigationBar(title: "Meditation")

        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sleepImageTapped))
        sleep.isUserInteractionEnabled = true
        sleep.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(growthImageTapped))
        personal_growth.isUserInteractionEnabled = true
        personal_growth.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(stressImageTapped))
        stress.isUserInteractionEnabled = true
        stress.addGestureRecognizer(tapGesture2)
        
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(anxietyImageTapped))
        anxiety.isUserInteractionEnabled = true
        anxiety.addGestureRecognizer(tapGesture3)
        
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(concentrationImageTapped))
        concentration.isUserInteractionEnabled = true
        concentration.addGestureRecognizer(tapGesture4)
        
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(increaseImageTapped))
        increase.isUserInteractionEnabled = true
        increase.addGestureRecognizer(tapGesture5)
        
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
    
    @objc func stressImageTapped(){
        if let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BetterSleepVC") as? BetterSleepVC {
            welcomeVC.medname = "Reduce Stress"
            welcomeVC.meditationImage = stress.image
            navigationController?.pushViewController(welcomeVC, animated: true)
            
        }
    }
    
    @objc func anxietyImageTapped(){
        if let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BetterSleepVC") as? BetterSleepVC {
            welcomeVC.medname = "Reduce Anxiety"
            welcomeVC.meditationImage = anxiety.image
            navigationController?.pushViewController(welcomeVC, animated: true)
            
        }
    }
    
    @objc func increaseImageTapped(){
        if let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BetterSleepVC") as? BetterSleepVC {
            welcomeVC.medname = "Increase Happiness"
            welcomeVC.meditationImage = increase.image
            navigationController?.pushViewController(welcomeVC, animated: true)
            
        }
    }
    @objc func concentrationImageTapped(){
        if let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BetterSleepVC") as? BetterSleepVC {
            welcomeVC.medname = "Better Concentration"
            welcomeVC.meditationImage = concentration.image
            navigationController?.pushViewController(welcomeVC, animated: true)
            
        }
    }
}
