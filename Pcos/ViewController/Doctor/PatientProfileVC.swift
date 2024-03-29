import UIKit

class PatientProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var occupationTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var bmiTF: UITextField!
    @IBOutlet weak var diseaseTF: UITextField!
    @IBOutlet weak var scoreTF: UITextField!
    
    @IBOutlet weak var hipTF: UITextField!
    
    @IBOutlet weak var waistTF: UITextField!
    
    @IBOutlet weak var ratioTF: UITextField!
    
    var shouldHideeditButton: Bool = false
    var selectedPatientName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
             let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
                profile.isUserInteractionEnabled = true
                profile.addGestureRecognizer(tapGestureRecognizer)
        
        
        ageTF.delegate = TextFieldHelper.shared
        occupationTF.delegate = TextFieldHelper.shared
        heightTF.delegate = TextFieldHelper.shared
        weight.delegate = TextFieldHelper.shared
        bmiTF.delegate = TextFieldHelper.shared
        hipTF.delegate = TextFieldHelper.shared
        waistTF.delegate = TextFieldHelper.shared
        scoreTF.delegate = TextFieldHelper.shared
        ratioTF.delegate = TextFieldHelper.shared
        
        customizeNavigationBar(title: "Profile")
        if shouldHideeditButton {
            editButton.isHidden = true
            disableUserInteractionForTextFields()
        } else {
            enableUserInteractionForTextFields()
        }
        fetchPatientDetails()
        makeProfileImageCircular()
    }
    @IBOutlet weak var editButton : UIButton!
    @IBAction func editProfile(_ sender: Any) {
        self.editProfileDetails()
        self.enableUserInteractionForTextFields()
        
    }
    func makeProfileImageCircular() {
           profile.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               profile.widthAnchor.constraint(equalToConstant: 100),
               profile.heightAnchor.constraint(equalToConstant: 100)
           ])
           profile.layer.cornerRadius = 50 
           profile.clipsToBounds = true
       }
    
    func disableUserInteractionForTextFields() {
        profile.isUserInteractionEnabled = false
        nameTF.isUserInteractionEnabled = false
        ageTF.isUserInteractionEnabled = false
        occupationTF.isUserInteractionEnabled = false
        heightTF.isUserInteractionEnabled = false
        weight.isUserInteractionEnabled = false
        bmiTF.isUserInteractionEnabled = false
        diseaseTF.isUserInteractionEnabled = false
        scoreTF.isUserInteractionEnabled = false
        hipTF.isUserInteractionEnabled = false
        waistTF.isUserInteractionEnabled = false
        ratioTF.isUserInteractionEnabled = false
    }
    
    func enableUserInteractionForTextFields() {
        nameTF.isUserInteractionEnabled = true
        ageTF.isUserInteractionEnabled = true
        occupationTF.isUserInteractionEnabled = true
        heightTF.isUserInteractionEnabled = true
        weight.isUserInteractionEnabled = true
        bmiTF.isUserInteractionEnabled = true
        diseaseTF.isUserInteractionEnabled = true
        scoreTF.isUserInteractionEnabled = true
        hipTF.isUserInteractionEnabled = true
        waistTF.isUserInteractionEnabled = true
        ratioTF.isUserInteractionEnabled = true
    }
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }

    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        presentImagePicker()
    }
    
    func presentImagePicker() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }

        profile.image = image
        let fileName = "image_\(Date().timeIntervalSince1970).jpg"
        
        uploadImage(image: image, fileName: fileName)
    }


       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }

    func uploadImage(image: UIImage, fileName: String) {
            guard let patientName = selectedPatientName,
                  let imageData = image.jpegData(compressionQuality: 0.5) else {
                print("Patient name is not set or image data could not be created.")
                return
            }

            guard let url = URL(string: ServiceAPI.profile_image) else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

            var body = Data()

            // Append patient name part
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"name\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(patientName)\r\n".data(using: .utf8)!)

            // Append image part with dynamic filename
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

            request.httpBody = body

            URLSession.shared.dataTask(with: request) { responseData, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Error uploading image: \(error.localizedDescription)")
                    }
                    return
                }

                guard let responseData = responseData else {
                    DispatchQueue.main.async {
                        print("No data received")
                    }
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                       let message = json["message"] as? String {
                        DispatchQueue.main.async {
                            print("Response: \(message)")
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("JSON error: \(error.localizedDescription)")
                    }
                }
            }.resume()
        }
    
    func fetchPatientDetails() {
        guard let name = selectedPatientName else {
            return
        }

        print("Patient Name:", name)

        let patientProfileAPIURL = "\(ServiceAPI.baseURL)profile.php?name=\(name)"

        APIHandler().getAPIValues(type: PatientProfileModel.self, apiUrl: patientProfileAPIURL, method: "GET") { result in
            switch result {
            case .success(let PatientProfileData):
                print("Received JSON response:", PatientProfileData)

                DispatchQueue.main.async {
                    self.nameTF.text = " \(PatientProfileData.patient_details?.name ?? "")"
                    self.ageTF.text = " \(PatientProfileData.patient_details?.age.map(String.init) ?? "")"
                    self.occupationTF.text = " \(PatientProfileData.patient_details?.Mobile_No ?? "")"
                    self.heightTF.text = " \(PatientProfileData.patient_details?.height ?? "")"
                    self.weight.text = " \(PatientProfileData.patient_details?.weight ?? "")"
                    self.bmiTF.text = " \(PatientProfileData.patient_details?.bmi ?? "")"
                    self.diseaseTF.text = " \(PatientProfileData.patient_details?.otherdisease ?? "")"
                    self.scoreTF.text = " \(PatientProfileData.patient_details?.obstetricscore ?? "")"
                    self.hipTF.text = " \(PatientProfileData.patient_details?.hip ?? "")"
                    self.waistTF.text = " \(PatientProfileData.patient_details?.waist ?? "")"
                    self.ratioTF.text = " \(PatientProfileData.patient_details?.hipwaist ?? "")"

                    // Load and set profile image
                    if let profileImageURL = PatientProfileData.patient_details?.profile_image,
                       let url = URL(string: profileImageURL) {
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            guard let data = data, error == nil else {
                                print("Error downloading profile image:", error?.localizedDescription ?? "Unknown error")
                                return
                            }
                            DispatchQueue.main.async {
                                self.profile.image = UIImage(data: data)
                                self.profile.contentMode = .scaleAspectFill
                                self.profile.layer.cornerRadius = self.profile.frame.width / 2
                                self.profile.clipsToBounds = true
                            }
                        }.resume()
                    }
                }
                
            case .failure(let error):
                print("Error fetching patient details:", error)
            }
        }
    }

    
    func editProfileDetails() {
        let formData: [String: String] = ["name": self.nameTF.text ?? "",
                                          "age": self.ageTF.text ?? "",
                                          "height": self.heightTF.text ?? "",
                                          "weight": self.weight.text ?? "",
                                          "Mobile_No": self.occupationTF.text ?? "",
                                          "otherdisease": self.diseaseTF.text ?? "",
                                          "obstetricScore": self.scoreTF.text ?? "",
                                          "bmi": self.bmiTF.text ?? "",
                                          "hip": self.hipTF.text ?? "",
                                          "waist": self.waistTF.text ?? "",
                                          "hipwaist": self.ratioTF.text ?? ""
        ]
        APIHandler().postAPIValues(type: EditProfileModel.self, apiUrl: ServiceAPI.editPatientprofile, method: "POST", formData: formData) { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
                DispatchQueue.main.async {
                    self?.navigateToPatientPlanVC()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func navigateToPatientPlanVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let patientPlanVC = storyboard.instantiateViewController(withIdentifier: "PatientPlanVC") as? PatientPlanVC {
            patientPlanVC.username5 = self.selectedPatientName ?? ""
            self.navigationController?.pushViewController(patientPlanVC, animated: true)
            
        }
    }

}
