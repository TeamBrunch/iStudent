//
//  SignUpVC.swift
//  iStudent
//
//  Created by Hansol Lee on 2017-11-03.
//  Copyright © 2017 TeamBrunch. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class SignUpVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var studentIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            
        } else {
            // Alert the user that there is no internet connection
            let alert = UIAlertController(title: "No Internet Connection!", message: "App may not function properly", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add okay action to alert, to return back to the app
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            
            // Present the alert to the user
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func genericAlert(alertTitle:String, alertMessage:String) {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func SignUpTapped(_ sender: Any) {
        let email = emailTextField.text;
        let firstName = firstNameTextField.text;
        let lastName = lastNameTextField.text;
        let studentId = studentIdTextField.text;
        let password = passwordTextField.text;
        
        if email == "" {
            self.genericAlert(alertTitle: "Required Field", alertMessage: "Please enter an email.")
        } else if firstName == "" {
            self.genericAlert(alertTitle: "Required Field", alertMessage: "Please enter a first name.")
        } else if lastName == "" {
            self.genericAlert(alertTitle: "Required Field", alertMessage: "Please enter a last name.")
        } else  if studentId == "" {
            self.genericAlert(alertTitle: "Required Field", alertMessage: "Please enter a Student ID.")
        } else if password == "" {
            self.genericAlert(alertTitle: "Required Field", alertMessage: "Please enter a password.")
        } else {
            Auth.auth().createUser(withEmail: email!, password: password!) { (user, error) in
                if error == nil {
                    let usersReference = self.ref.child("users")
                    let uid = user?.uid
                    let newUserReference = usersReference.child(uid!)
                    newUserReference.setValue(
                        [
                            "studentId" :self.studentIdTextField.text!,
                            "firstName" : self.firstNameTextField.text!,
                            "lastName"  :self.lastNameTextField.text!,
                            "email"     : self.emailTextField.text!
                        ])
                    print(" newUserReference description : \(newUserReference.description())")
                    // self.performSegue(withIdentifier: "SignupSegue", sender: nil)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    self.genericAlert(alertTitle: "Error", alertMessage: (error?.localizedDescription)!)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
