import UIKit
import AVFoundation

class NightIslandVC: UIViewController, AVAudioPlayerDelegate {
    var namemusic : String = ""
    @IBOutlet weak var audioname: UILabel!
    @IBOutlet weak var playOt: UIButton!
    @IBOutlet weak var backward: UIButton!
    @IBOutlet weak var forward: UIButton!
    @IBOutlet weak var progressTime: UISlider!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    
    var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioname.text = namemusic
        setupAudioPlayer()
        progressTime.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopAudio()
    }
    
    func setupAudioPlayer() {
        guard let audioURLString = UserDefaults.standard.string(forKey: "audioURL"),
              let audioURL = URL(string: audioURLString) else {
            print("Audio URL not found.")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: audioURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to download audio data with error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Audio data is nil.")
                return
            }
            
            do {
                self.audioPlayer = try AVAudioPlayer(data: data)
                self.audioPlayer?.delegate = self
                self.audioPlayer?.prepareToPlay()
                DispatchQueue.main.async {
                    self.progressTime.maximumValue = Float(self.audioPlayer?.duration ?? 0)
                    self.updateUI() // Initial UI update
                }
            } catch {
                print("Failed to initialize audio player with error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }

    
    @IBAction func forwardAC(_ sender: Any) {
        seekForward()
    }
    
    @IBAction func backwordAC(_ sender: Any) {
        seekBackward()
    }
    
    @IBAction func playPause(_ sender: Any) {
        if audioPlayer?.isPlaying == true {
            pauseAudio()
            playOt.setImage(UIImage(named: "playy"), for: .normal)
        } else {
            playAudio()
            playOt.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    func playAudio() {
        audioPlayer?.play()
        startTimer()
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        stopTimer()
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        stopTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateUI() {
        if let player = audioPlayer {
            progressTime.value = Float(player.currentTime)
            startTime.text = formatTime(time: player.currentTime)
            remainingTime.text = formatTime(time: (player.duration - player.currentTime))
        }
    }
    
    func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func sliderValueChanged() {
        if let player = audioPlayer {
            player.currentTime = TimeInterval(progressTime.value)
        }
    }
    
    func seekBackward() {
        if let player = audioPlayer {
            let currentTime = player.currentTime
            let newTime = max(currentTime - 15.0, 0)
            player.currentTime = newTime
            updateUI()
        }
    }
    
    func seekForward() {
        if let player = audioPlayer {
            let currentTime = player.currentTime
            let newTime = min(currentTime + 15.0, player.duration)
            player.currentTime = newTime
            updateUI()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playOt.setImage(UIImage(named: "playy"), for: .normal)
        stopTimer()
        updateUI() // Reset UI to the start of the audio
    }
}
