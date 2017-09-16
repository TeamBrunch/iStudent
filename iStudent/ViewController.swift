//
//  ViewController.swift
//  iStudent
//
//  Created by Vincent Lee on 2017-09-15.
//  Copyright © 2017 TeamBrunch. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var statusMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated : Bool ) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            //self.userField.text = ;
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signInBtn(_ sender: UIButton) {
    
        if let email = self.userField.text, let password = self.passField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                // ...
                if let error = error {
                    self.statusMessage.text = error.localizedDescription
                    return
                }
                self.statusMessage.text = "nice you signed in"
                
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                //in "Main" your  storyboard name
                
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                
                //in place of Login Page your storyboard identifier name
                
                self.present(secondViewController, animated: true)
            }
        } else {
            self.statusMessage.text = "incorrect credentials maybe"
        }
        
    }
    
}

