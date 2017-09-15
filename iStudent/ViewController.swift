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
        let email = userField.text;
        let password = passField.text;
        /*Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
        }*/

    }
    
}

