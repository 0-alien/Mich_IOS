//
//  RegisterViewController.swift
//  Mich
//
//  Created by Gigi Pataraia on 9/15/16.
//  Copyright © 2016 Gigi. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleMaps
import GooglePlaces

class RegisterViewController: UIViewController, UITextFieldDelegate, GMSAutocompleteViewControllerDelegate {
    @IBOutlet weak var signUpName: UITextField!
    @IBOutlet weak var signUpUsername: UITextField!
    @IBOutlet weak var signUpEmail: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpConfirmPassword: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var placeOfBirth: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var IfCheckedButton: UIButton!
    @IBOutlet weak var TermsAndCondittionsBTN: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        IfCheckedButton.isHidden = true
        signUpButton.isEnabled = false

        signUpName.layer.shadowOpacity = 0.3;
        signUpName.layer.shadowRadius = 1.0;
        signUpName.layer.shadowColor = UIColor.black.cgColor;
        signUpName.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpName.layer.masksToBounds = false

        signUpUsername.layer.shadowOpacity = 0.3;
        signUpUsername.layer.shadowRadius = 1.0;
        signUpUsername.layer.shadowColor = UIColor.black.cgColor;
        signUpUsername.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpUsername.layer.masksToBounds = false

        signUpEmail.layer.shadowOpacity = 0.3;
        signUpEmail.layer.shadowRadius = 1.0;
        signUpEmail.layer.shadowColor = UIColor.black.cgColor;
        signUpEmail.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpEmail.layer.masksToBounds = false
        
        signUpPassword.layer.shadowOpacity = 0.3;
        signUpPassword.layer.shadowRadius = 1.0;
        signUpPassword.layer.shadowColor = UIColor.black.cgColor;
        signUpPassword.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpPassword.layer.masksToBounds = false

        signUpConfirmPassword.layer.shadowOpacity = 0.3;
        signUpConfirmPassword.layer.shadowRadius = 1.0;
        signUpConfirmPassword.layer.shadowColor = UIColor.black.cgColor;
        signUpConfirmPassword.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpConfirmPassword.layer.masksToBounds = false
        
        birthDate.layer.shadowOpacity = 0.3;
        birthDate.layer.shadowRadius = 1.0;
        birthDate.layer.shadowColor = UIColor.black.cgColor;
        birthDate.layer.shadowOffset = CGSize(width: -4, height: 4)
        birthDate.layer.masksToBounds = false

        placeOfBirth.layer.shadowOpacity = 0.3;
        placeOfBirth.layer.shadowRadius = 1.0;
        placeOfBirth.layer.shadowColor = UIColor.black.cgColor;
        placeOfBirth.layer.shadowOffset = CGSize(width: -4, height: 4)
        placeOfBirth.layer.masksToBounds = false

        
        signUpButton.layer.shadowOpacity = 0.3;
        signUpButton.layer.shadowRadius = 1.0;
        signUpButton.layer.shadowColor = UIColor.black.cgColor;
        signUpButton.layer.shadowOffset = CGSize(width: -4, height: 4)
        signUpButton.layer.masksToBounds = false
      
        signUpName.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signUpName.attributedPlaceholder = NSAttributedString(string:"Name", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpUsername.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signUpUsername.attributedPlaceholder = NSAttributedString(string:"Username", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpEmail.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signUpEmail.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpPassword.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signUpPassword.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpConfirmPassword.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        signUpConfirmPassword.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        birthDate.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        birthDate.attributedPlaceholder = NSAttributedString(string:"Date Of Birth", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        placeOfBirth.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        placeOfBirth.attributedPlaceholder = NSAttributedString(string:"Place Of Birth", attributes:[NSForegroundColorAttributeName: UIColor(red: 0, green: 0, blue: 0, alpha: 1)])
        
        signUpButton.backgroundColor = UIColor (red:243 / 255.0, green:92 / 255.0, blue:59 / 255.0, alpha:1)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default);
        self.navigationController?.navigationBar.shadowImage = UIImage();
        self.navigationController?.navigationBar.isTranslucent = true

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        createDatePicker()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createDatePicker () {
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        birthDate.inputAccessoryView = toolbar
        birthDate.inputView = datePicker
    }
    
    func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        birthDate.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @IBAction func placeOfBirthAutoComplete(_ sender: Any) {
       
    }

    @IBAction func signUpButton(_ sender: Any) {
        let redColor  = #colorLiteral(red: 0.7740760446, green: 0.1117314473, blue: 0.09814801067, alpha: 1)
        let name = signUpName.text!
        let username =  signUpUsername.text!
        let email = signUpEmail.text!
        let password = signUpPassword.text!
        let confirmPassword = signUpConfirmPassword.text!

        if(password != confirmPassword){
            signUpConfirmPassword.text = "";
            signUpPassword.text = "";
            signUpPassword.layer.borderColor = redColor.cgColor;
            signUpPassword.layer.borderWidth = 2.0;
            signUpConfirmPassword.layer.borderColor = redColor.cgColor;
            signUpConfirmPassword.layer.borderWidth = 2.0;
            return;
        }
        MichTransport.register(username:username, email: email, password: password, name:name, successCallbackForRegister: onRegister, errorCallbackForRegister: onErrorRegister)
    }
    
    func onRegister(){
        let refreshAlert = UIAlertController(title: "SUCCESS", message: "You Have Successfuly Registered", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let storyboard = UIStoryboard(name: "Cabinet", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(vc, animated: false, completion: nil)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func onErrorRegister(error: DefaultError){
        let alert = UIAlertController(title: "Alert", message: error.errorString, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == signUpConfirmPassword || textField == signUpPassword){
            scrollView.setContentOffset(CGPoint(x:0, y:200), animated: true)
        }
        else if(textField == placeOfBirth){
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self as? GMSAutocompleteViewControllerDelegate
            let filter = GMSAutocompleteFilter()
            filter.type = GMSPlacesAutocompleteTypeFilter.city
            autocompleteController.autocompleteFilter = filter
            present(autocompleteController, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       if(textField == signUpConfirmPassword || textField == signUpPassword){
            scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func RadioButtonCheked(_ sender: Any) {
        IfCheckedButton.isHidden = false;
        signUpButton.isEnabled = true
    }
    
    @IBAction func IfCheckedAct(_ sender: Any) {
        IfCheckedButton.isHidden = true
        signUpButton.isEnabled = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        textField.resignFirstResponder()
        signUpButton(self)
        return true
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        placeOfBirth.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}



