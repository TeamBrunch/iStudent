//
//  SignUpVC.swift
//  iStudent
//
//  Created by Hansol Lee on 2017-11-03.
//  Copyright © 2017 TeamBrunch. All rights reserved.
//

import UIKit
import Firebase;
import FirebaseDatabase


class SignUpVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var studentIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
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
    
    @IBAction func SignUpTapped(_ sender: Any) {
        
        let email = emailTextField.text;
        let firstName = firstNameTextField.text;
        let lastName = lastNameTextField.text;
        let studentId = studentIdTextField.text;
        let password = passwordTextField.text;
        
        if (email != nil), (firstName != nil), (lastName != nil), (studentId != nil), (password != nil)
        {
            Auth.auth().createUser(withEmail: email!, password: password!)
            { (user: User?, error: Error?) in
                if let firebaseError = error
                {
                    print(firebaseError.localizedDescription)
                    return
                }
                let ref = Database.database().reference()
                let usersReference = ref.child("users")
                let uid = user?.uid
                let newUserReference = usersReference.child(uid!)
                newUserReference.setValue(["studentId":self.studentIdTextField.text!, "firstName": self.firstNameTextField.text!,"lastName":self.lastNameTextField.text!, "email": self.emailTextField.text!, ])
                print(" newUserReference description : \(newUserReference.description())")
            }
            performSegue(withIdentifier: "SignupSegue", sender: nil)
        } else {
            print("fail to save in firebase")
        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

}
