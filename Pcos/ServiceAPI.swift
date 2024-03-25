//
//  ServiceAPI.swift
//  Pcos
//
//  Created by Karthik Babu on 17/11/23.
//

import Foundation


struct ServiceAPI {
    
    static var baseURL = "http://192.168.0.239/pcos_DB/"
    static var loginURL = baseURL+"loginPost.php"
    static var profileURL = baseURL+"personaldetails.php"
    static var forgotPasswordURL = baseURL+"forgotpassword.php"
    static var SignupURL = baseURL+"signup.php"
    static var patientlistURL = baseURL+"patientlist.php"
    static var weightgoalURL = baseURL+"weightgoals.php"
    static var patientprofileURL = baseURL+"profile.php"
    static var editPatientprofile = baseURL+"edit.php"
    static var todaysprogress = baseURL+"todayprogress.php"
    static var qnsAnsUrl = baseURL+"qns.php"
    static var patientScoreCategory = baseURL+"category.php"
    static var stepsGraph = baseURL+"stepsgraph.php?"
    static var medicalrecords = baseURL+"medicalrecords.php"

}
