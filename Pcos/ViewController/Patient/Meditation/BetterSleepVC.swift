import UIKit

struct Meditation: Codable {
    let audioName: String
    let audioPath: String
    let audioDescription: String
    let duration: String
    
    enum CodingKeys: String, CodingKey {
        case audioName = "audio_name"
        case audioPath = "audio_path"
        case audioDescription = "audio_description"
        case duration
    }
}
class BetterSleepVC: UIViewController {
    
    var medname: String? = ""
    var meditationImage: UIImage? // Property to hold the passed image
    
    @IBOutlet weak var audioname: UILabel!
    @IBOutlet weak var describ: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var audioimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAudioInfo()
        
        // Set the passed image to your UIImageView
        audioimage.image = meditationImage
    }
    
    func fetchAudioInfo() {
        guard let url = URL(string: "\(ServiceAPI.baseURL)meditation.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters = "category=\(medname ?? "")"
        request.httpBody = parameters.data(using: .utf8)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let meditation = try JSONDecoder().decode(Meditation.self, from: data)
                DispatchQueue.main.async {
                    self?.updateUI(with: meditation)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func updateUI(with meditation: Meditation) {
        audioname.text = meditation.audioName
        describ.text = meditation.audioDescription
        time.text = meditation.duration
        
        // Save the audio URL for later use
        UserDefaults.standard.set(meditation.audioPath, forKey: "audioURL")
    }
    
    @IBAction func play(_ sender: Any) {
        let slpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NightIslandVC") as! NightIslandVC
        slpVC.namemusic = medname ?? ""
        self.navigationController?.pushViewController(slpVC, animated: true)
    }
}
