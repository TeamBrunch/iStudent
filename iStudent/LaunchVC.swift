//
//  LaunchVC.swift
//  iStudent
//
//  Created by Hansol Lee on 2017-11-03.
//  Copyright © 2017 TeamBrunch. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogOutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
  

}
