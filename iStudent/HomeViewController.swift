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
    
    @IBAction func LoginTapped(_ sender: Any) {
        if let email = emailHomeVCTextField.text, let password = passwordHomeVCTextField.text
        {
            Auth.auth().signIn(withEmail: email, password: password)
            { _, error in
                if let firebaseError = error
                {
                    print(firebaseError.localizedDescription)
                    let alert = UIAlertController(title: "IStudent", message: "Login Failed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                self.performSegue(withIdentifier: "loggedInSegue", sender: nil)
            }
          
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

