//
//  HomeViewController.swift
//  iStudent
//
//  Created by Vincent Lee on 2017-09-15.
//  Copyright © 2017 TeamBrunch. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var passwordHomeVCTextField: UITextField!
    @IBOutlet weak var emailHomeVCTextField: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var userDisplay: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func LoginTapped(_ sender: Any) {
        let userEmail = self.emailHomeVCTextField.text
        let userPassword = self.passwordHomeVCTextField.text
        
        if userEmail == "" || userPassword == "" {
            self.genericAlert(alertTitle: "Required Fields", alertMessage: "Please enter an email and a password.")
        } else {
            Auth.auth().signIn(withEmail: userEmail!, password: userPassword!) { (user, error) in
                if error == nil {
                    // sign in sucess
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

