import Foundation

struct PatientProfileModel: Codable {
    let patient_details: PatientDetails?

    struct PatientDetails: Codable {
        let name: String?
        let age: Int?  // Keep age as Int
        let Mobile_No: String?
        let height: String?
        let weight: String?
        let bmi: String?
        let otherdisease: String?
        let obstetricscore: String?
        let hip: String?
        let waist: String?
        let hipwaist: String?
        let profile_image: String?
    }
}
