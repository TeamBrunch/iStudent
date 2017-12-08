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
    
}

