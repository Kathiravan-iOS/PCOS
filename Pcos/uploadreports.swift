import UIKit

class uploadreports: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var name1: String = ""
    
    @IBOutlet weak var report: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func uploadBT(_ sender: Any) {
        if uploadButton.title(for: .normal) == "Submit" {
            if let imageToUpload = report.image {
                uploadImage(image: imageToUpload, name: name1)
            }
        } else {
            openGallery()
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            report.contentMode = .scaleAspectFit
            report.image = pickedImage
            uploadButton.setTitle("Submit", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage, name: String) {
        guard let url = URL(string: "\(ServiceAPI.baseURL)/medicalrecords.php") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = image.jpegData(compressionQuality: 0.5)!
        var body = Data()
        
        // Append image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
     
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(name)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Error: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    print("No data received")
                    self.showAlert(title: "Error", message: "No data received")
                }
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = json["message"] as? String {
                    DispatchQueue.main.async {
                        self.showAlert(title: "Response", message: message)
                        self.uploadButton.setTitle("Upload", for: .normal)
                        self.report.image = nil
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("JSON error: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Failed to parse response")
                }
            }
        }.resume()
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // Ensure strong self reference is captured for navigation
            guard let strongSelf = self else { return }

            strongSelf.dismiss(animated: true) {
                strongSelf.navigateToMedicalRecordHomeVC()
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func navigateToMedicalRecordHomeVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let medicalRecordHomeVC = storyboard.instantiateViewController(withIdentifier: "PatientPlanVC") as? PatientPlanVC {
            if let navigator = navigationController {
                medicalRecordHomeVC.username5 = name1
                navigator.pushViewController(medicalRecordHomeVC, animated: true)
            } else {
                present(medicalRecordHomeVC, animated: true, completion: nil)
            }
        }
    }


}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
