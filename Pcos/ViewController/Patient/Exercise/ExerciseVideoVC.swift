import UIKit
import AVKit
import AVFoundation

struct ExerciseDetail: Codable {
    let exercise_name: String
    let video_description: String
    let video_url: String
    let duration: String
    let process: String
}

class ExerciseVideoVC: UIViewController {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var exerciseImg: UIImageView!
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var process: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var watchButton: UIButton!

    @IBOutlet weak var exerciseimage: UIImageView!
    
    var playerViewController: AVPlayerViewController?
    var player: AVPlayer?
     
    var exerciseNameStr : String?
    var exerciseImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExerciseDetails()
            watchButton.addTarget(self, action: #selector(watchButtonTapped), for: .touchUpInside)
//            exerciseImg.image = exerciseImage
    }

    func loadExerciseDetails() {
        guard let url = URL(string: "\(ServiceAPI.baseURL)exercise.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: [String: Any] = ["exercise_name": exerciseNameStr ?? ""]
        request.httpBody = parameters.customPercentEncoded()

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let exerciseDetail = try JSONDecoder().decode(ExerciseDetail.self, from: data)
                DispatchQueue.main.async {
                    self?.updateUI(with: exerciseDetail)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func updateUI(with exerciseDetail: ExerciseDetail) {
        exerciseName.text = exerciseDetail.exercise_name
        descriptionLabel.text = exerciseDetail.video_description
        duration.text = exerciseDetail.duration
        process.text = exerciseDetail.process

        if let videoURL = URL(string: exerciseDetail.video_url) {
            player = AVPlayer(url: videoURL)
            playerViewController = AVPlayerViewController()
            playerViewController?.player = player
        }
    }

    @objc func watchButtonTapped() {
        exerciseImg.isHidden = false
        if let playerViewController = playerViewController {
            present(playerViewController, animated: true) {
                self.player?.play()
            }
        }
    }
}

extension Dictionary {
    func customPercentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
