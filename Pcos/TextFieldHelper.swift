//
//  TextFieldHelper.swift
//  Pcos
//
//  Created by SAIL on 28/03/24.
//

import UIKit

class TextFieldHelper: NSObject, UITextFieldDelegate {
    
    static let shared = TextFieldHelper()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
