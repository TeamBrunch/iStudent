//
//  LaunchVC.swift
//  iStudent
//
//  Created by Hansol Lee on 2017-11-03.
//  Copyright © 2017 TeamBrunch. All rights reserved.
//

import UIKit
import Firebase

class LaunchVC: UIViewController {
    var uuid = ""
    var name = ""
    var senderDisplayName = ""
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    private var channelRefHandle: DatabaseHandle?
    private var channels = [[String:String]]()
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = name
        self.senderDisplayName = (Auth.auth().currentUser?.email)!
        //query
        self.observeChannels();
        print("finished querying")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogOutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinChatButton(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            let channel = self.channels[0]; //get the first
            performSegue(withIdentifier: "LaunchToBeaconChat", sender: channel)
        } else {
            // Alert the user that there is no internet connection
            let alert = UIAlertController(title: "No Internet Connection!", message: "App may not function properly", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add okay action to alert, to return back to the app
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            
            // Present the alert to the user
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let chatVc = segue.destination as! ChatViewController
        print("prepare", channels)
        let channel = self.channels[0]
        chatVc.senderDisplayName = self.senderDisplayName
        chatVc.channel = channel
        chatVc.title = channel["name"]
        chatVc.channelRef = self.channelRef.child(channel["id"]!)
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
    
    private func observeChannels() {
        // Use the observe method to listen for new
        // channels being written to the Firebase DB
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in // 1
            let channelData = snapshot.value as! Dictionary<String, AnyObject> // 2
            let id = snapshot.key
            print("id", id, "data",channelData)
            if let name = channelData["name"] as! String!, name.count > 0 { // 3
                self.channels.append(["id": id, "name": name]);
                print(self.channels)
                //self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
}
