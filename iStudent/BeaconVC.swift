//
//  BeaconVC.swift
//  iStudent
//
//  Created by Matthew Li on 2017-11-03.
//  Copyright © 2017 TeamBrunch. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconVC: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var checks: Int = 1
    @IBOutlet weak var bText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
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
        var desc: String = ""
        if beacons.count > 0 {
            print(beacons)
            for beacon in beacons{
                desc +=  "UUID: \(beacon.proximityUUID). \nmajor: \(beacon.major)\nminor: \(beacon.minor) \nrssi: \(beacon.rssi) \naccuracy: \(beacon.accuracy) \n\n"
            }
        } else {
            desc += "Beacon not found"
        }
        self.bText.text = desc
    }
    
    func updateDistance(_ distance: CLProximity) {
        switch distance {
        case .unknown:
            self.bText.text = "Unknown"
            
        case .far:
            self.bText.text = "Far"
            
        case .near:
            self.bText.text = "Near"
            
        case .immediate:
            self.bText.text = "Immediate"
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "C6C4C829-4FD9-4762-837C-DA24C665015A")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "Kontakt Test")
        
        beaconRegion.notifyEntryStateOnDisplay = true
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        
        //locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
}
