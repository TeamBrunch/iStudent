//
//  BeaconTableVC.swift
//  iStudent
//
//  Created by Vincent Lee on 2017-11-17.
//  Copyright © 2017 TeamBrunch. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class BeaconTableVC: UITableViewController, CLLocationManagerDelegate {
    
    let reuseidentifier = "BeaconCell"
    var locationManager: CLLocationManager!
    var beaconCollection = [String:CLBeacon]() //uuid:[info]
    var firebaseBeaconCollection = [String:String]() //uuid:firebase name
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return beaconCollection.count == 0 ? 1 : beaconCollection.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> BeaconTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifier, for: indexPath) as! BeaconTableViewCell
        // Configure the cell...
        if(beaconCollection.count != 0) {
            let uuid = Array(beaconCollection)[indexPath.row].key
            let name = firebaseBeaconCollection[uuid]
            cell.name.text = name!
            cell.distance.text = beaconCollection[uuid]!.proximity.rawValue.description
        } else {
            cell.name.text = "No beacon in range"
            cell.distance.text = "...searching"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uuid = Array(beaconCollection)[indexPath.row].key
        let name = firebaseBeaconCollection[uuid]
        if(name != "default") {
            let launchVC = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVC") as! LaunchVC
            launchVC.uuid = uuid
            launchVC.name = name!
            self.navigationController?.pushViewController(launchVC, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        //reset beacons
        self.beaconCollection = [:]
        self.firebaseBeaconCollection = [:]
        if beacons.count > 0 {
            for beacon in beacons{
                if(validateDistance(beacon.proximity)) {
                    firebaseBeaconRefExists(uuid: beacon.proximityUUID.uuidString, completion: { found, name in
                        if(found) {
                            self.beaconCollection[beacon.proximityUUID.uuidString] = beacon
                            self.firebaseBeaconCollection[beacon.proximityUUID.uuidString] = name
                            self.tableView.reloadData() //reload after each
                        } else {
                            print("firebase beacon result not found", found, name)
                        }
                    });
                }
            }
        }
    }
    
    func validateDistance(_ distance: CLProximity) -> Bool {
        
        if(distance == .unknown || distance == .far) {
            print("distance invalid")
            return false
        }
        //.immediate, .near
        return true
    }
    
    func firebaseBeaconRefExists(uuid: String, completion: @escaping (Bool, String) -> Void) -> Void  {
        var found = false
        var name = ""
        self.ref.child("beacons")
        .observe(.value, with:{ (snapshot: DataSnapshot) in
            for snap in snapshot.children {
                let data = (snap as! DataSnapshot)
                found = uuid.caseInsensitiveCompare(data.key) == ComparisonResult.orderedSame
                if(found) {
                    name = data.value as! String
                    break
                }
            }
            completion(found, name);
        })
    }
    
    func startScanning() {
        print("scanning")
        let uuid = UUID(uuidString: "C6C4C829-4FD9-4762-837C-DA24C665015A")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "Kontakt Test")
        
        beaconRegion.notifyEntryStateOnDisplay = true
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        
        //locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
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
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
