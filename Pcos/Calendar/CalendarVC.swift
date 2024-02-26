//
//  CalendarVC.swift
//  Pcos
//
//  Created by SAIL on 05/01/24.
//

import UIKit

class CalendarDelegate: NSObject, UICalendarViewDelegate {
    @available(iOS 16.0, *)
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return .none
    }
}

@available(iOS 16.0, *)
class CalendarVC: UIViewController, UICalendarViewDelegate, UICalendarSelectionMultiDateDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var calendar_View: UIView!
    var usernameForCalendar: String = ""
    var selectedDatesArray: [String] = [] // Array to store formatted dates
    var multiSelection: UICalendarSelectionMultiDate!
    var monthSelection = DateComponents()
    var cycle = String(365)
    var intCycle = Int()
    var calendarDelegate: CalendarDelegate?
    var selectedDateArray: [Date]?
    var calendarView: UICalendarView = {
        let calendarObj = UICalendarView()
        calendarObj.calendar = Calendar(identifier: .gregorian)
        return calendarObj
    }()
    var dateComponentsArray: [DateComponents] = []
    let calendar = Calendar.current
    var selectedPatientName = ""
    var patientSelectedDates: PatientDateModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setupCalender()
        calendarDelegate = CalendarDelegate()
        calendarView.delegate = self
        self.fetchSelectedDates()
        customizeNavigationBar(title: "Menstrual Calendar")
    }
//    
//    func fetchSelectedDates() {
//        if !self.selectedPatientName.isEmpty {
//            let param = ["name":self.selectedPatientName]
//            APIHandler.shared.postAPIValues(type: PatientDateModel.self, apiUrl: "\(ServiceAPI.baseURL)calenderD.php", method: "POST", formData: param) { response in
//                switch response {
//                case .success(let result):
//                    print("-result",result)
//                    self.patientSelectedDates = result
//                    self.showSelectedDates()
//                case .failure(let err):
//                    print("------err",err)
//                }
//            }
//        }
//    }
    func fetchSelectedDates() {
        if !self.selectedPatientName.isEmpty {
            let param = ["name": self.selectedPatientName]
            APIHandler.shared.postAPIValues(type: PatientDateModel.self, apiUrl: "\(ServiceAPI.baseURL)calenderD.php", method: "POST", formData: param) { response in
                switch response {
                case .success(let result):
                    print("-result",result)
                    self.patientSelectedDates = result
                    // Show selected dates in the calendar view
                    self.showSelectedDates()
                    
                    // Disable user interaction for selected dates
//                    self.disableInteractionWithSelectedDates()
                case .failure(let err):
                    print("------err",err)
                }
            }
        }
    }
//    func disableInteractionWithSelectedDates() {
//        // Iterate over the selected dates and create overlays to intercept touch events
//        for dateComponents in self.dateComponentsArray {
//            if let cell = self.calendarView.cell(forDateComponents: dateComponents) {
//                let overlayView = UIView(frame: cell.frame)
//                overlayView.backgroundColor = .clear
//                overlayView.isUserInteractionEnabled = true // Enable user interaction with the overlay view
//                self.calendar_View.addSubview(overlayView)
//            }
//        }
//    }




    
    func showSelectedDates() {
        
        if  let selectedDates = patientSelectedDates?.dates {
            // Iterate over each Date object and convert to DateComponents
            for date in selectedDates {
                print("---date",date.calendarDate)
                let dateFormatter = DateFormatter()

                // Set the date format to match your input string
                dateFormatter.dateFormat = "yyyy-MM-dd"

                // Parse the string into a Date object
                guard let selectedDate = dateFormatter.date(from: date.calendarDate) else {return}
                    print(date) // Output: 2024-01-27 00:00:00 +0000
                let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: selectedDate)
                dateComponentsArray.append(components)
            }
            multiSelection.setSelectedDates(dateComponentsArray, animated: true)
            
        }
    }
    
    func setUpUI() {
        calendarView.tintColor = .white
        self.calendar_View.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.leadingAnchor.constraint(equalTo: calendar_View.leadingAnchor).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: calendar_View.trailingAnchor).isActive = true
        calendarView.topAnchor.constraint(equalTo: calendar_View.topAnchor).isActive = true
        calendarView.bottomAnchor.constraint(equalTo: calendar_View.bottomAnchor).isActive = true
        calendar_View.layoutIfNeeded()
    }
    
    func setupCalender() {
        let multiDaySelection = UICalendarSelectionMultiDate(delegate: self)
        let selectedDates = selectedDatesArray.compactMap { stringDate -> Date? in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            return formatter.date(from: stringDate)
        }

        let calendar = Calendar(identifier: .gregorian)
        let dateComponentsArray: [DateComponents] = selectedDates.map { date in
            calendar.dateComponents([.year, .month, .day], from: date)
        }
        multiDaySelection.selectedDates = dateComponentsArray
        calendarView.selectionBehavior = multiDaySelection
        let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        self.multiSelection = multiDaySelection
        self.monthSelection = currentDate
    }
    

    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, canSelectDate dateComponents: DateComponents) -> Bool {
        // Convert the selected date components to a Date object
        guard let selectedDate = calendar.date(from: dateComponents) else {
            return false
        }
        
        // Check if the selected date is already in the array of selected dates
        if selectedDateArray?.contains(selectedDate) ?? false {
            return false // Date is already selected, prevent selection
        }
        
        // Allow selection if the date is not already selected
        return true
    }


    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didSelectDate dateComponents: DateComponents) {
        let calendar = Calendar(identifier: .gregorian)
        let selectedDate = calendar.date(from: dateComponents)!
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = formatter.string(from: selectedDate)
        
        // Append the formatted date to the array
        selectedDatesArray.append(formattedDate)
        print("Selected Dates Array: \(selectedDatesArray)")
        print(formattedDate, "formattedDate")
    }
    
    func multiDateSelection(_ selection: UICalendarSelectionMultiDate, didDeselectDate dateComponents: DateComponents) {
        let calendar = Calendar(identifier: .gregorian)
        let deselectedDate = calendar.date(from: dateComponents)!
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let formattedDate = formatter.string(from: deselectedDate)
        print(formattedDate, "formattedDate")
    }

    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        self.fetchSelectedDates()

            // Call a function to send data to the server when the view is about to disappear
            sendDataToServer()
        }

    func sendDataToServer() {
        print("Username: \(self.selectedPatientName)")
        print("Selected Dates Array: \(selectedDatesArray)")
        guard !selectedDatesArray.isEmpty else {
            print("No selected dates to send to the server.")
            return
        }
        let names = selectedPatientName
        let formattedDates = selectedDatesArray.compactMap { formatDate($0) }
        let postData: [String: Any] = [
            "name": names,
            "dates": formattedDates
        ]

        do {
            // Convert the dictionary to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])

            // Prepare the request
            guard let url = URL(string: "\(ServiceAPI.baseURL)calender.php") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            // Make the API request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle the response
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    do {
                        // Parse the JSON response
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                        if let jsonResponse = jsonResponse {
                            // Print the entire JSON response
                            print("JSON Response: \(jsonResponse)")

                            if let message = jsonResponse["message"] as? String {
                                // Check if the "message" key exists in the response
                                print("Server Response: \(message)")
                            } else if let error = jsonResponse["error"] as? String {
                                // Check if there's an error message in the response
                                print("Server Error: \(error)")
                            } else {
                                print("Invalid JSON response format")
                            }
                        } else {
                            print("Invalid JSON response")
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
            task.resume()
        } catch {
            print("Error converting data to JSON: \(error)")
        }
    }




    func formatDate(_ date: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"

        if let formattedDate = formatter.date(from: date) {
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: formattedDate)
        } else {
            return nil
        }
    }
    
    func generateRandomDates(count: Int) -> [Date] {
        var dates: [Date] = []
        
        // Set up date range for randomness
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: startDate)!
        
        for _ in 0..<count {
            // Generate a random time interval between start and end date
            let randomTimeInterval = TimeInterval(arc4random_uniform(UInt32(endDate.timeIntervalSince(startDate))))
            
            // Create a random date within the range
            if let randomDate = Calendar.current.date(byAdding: .second, value: Int(randomTimeInterval), to: startDate) {
                dates.append(randomDate)
            }
        }
        
        return dates
    }

    }
