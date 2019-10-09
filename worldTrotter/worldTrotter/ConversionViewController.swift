//
//  ConversionViewController.swift
//  worldTrotter
//
//  Created by Marzieh on 2019-10-07.
//  Copyright © 2019 Myph. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("ConversionViewController loaded its view.")
        
        updateCelsiusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let date = Date()
        let currentHour = Calendar.current.component(.hour, from: date)
        if currentHour > 18 || currentHour < 7 {
            self.view.backgroundColor = UIColor.darkGray
        } else {
            self.view.backgroundColor = UIColor.lightGray
        }
    }
    
    
    
    
    @IBOutlet var celsiusLabel: UILabel!
    var fahrenheitValue : Measurement<UnitTemperature>? {
        didSet { //property observer
            updateCelsiusLabel ()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? { // computed property
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
        
    }
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func fahrenhietFieldEditingChanged(_ textField: UITextField) {
        
        if let text = textField.text, let value = Double(text) { //first you check to see if the textfield has
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit) //some text, then whether it can be
        } else {                                                           // represented by a Double, if that
            fahrenheitValue = nil                                           // checks out, then the Fahreneit                                                                                                  //value is set to a Measurement                                                                                                    //initialized with that Double value.
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    let numberFormatter: NumberFormatter = {  // This is a closure to instantiate the number formatter
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    } ()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existingTextHasDecimalSeperator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        let replacementTextHasAlphabeticCharacter = string.rangeOfCharacter(from: NSCharacterSet.letters)
        
        if ((existingTextHasDecimalSeperator != nil && replacementTextHasDecimalSeparator != nil ) || replacementTextHasAlphabeticCharacter != nil) {
            return false
        } else {
            return true
        }
        
    }
}
