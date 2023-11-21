//
//  ViewController.swift
//  SampleApp
//
//  Created by Jonathan Reiss on 9/23/18.
//  Copyright © 2018 SpotSense. All rights reserved.
//

import UIKit
import SpotSense
import CoreLocation
import UserNotifications // required if sending notifications with SpotSense


class ViewController: UIViewController, UNUserNotificationCenterDelegate, SpotSenseDelegate  {
    func didFindBeacon(beaconScanner: SpotSense, beacon: CLBeacon, data: [String:Any]) {
        
        spotsense.handleBeaconEnterState(beaconScanner: beaconScanner, data: data)
        
    }

    func didLoseBeacon(beaconScanner: SpotSense, beacon: CLBeacon, data: [String:Any]) {
        spotsense.handleBeaconExitState(beaconScanner: spotsense, data: data)
    }
    
    func didUpdateBeacon(beaconScanner: SpotSense, beacon: CLBeacon, data: [String:Any]) {
        
    }
    
    func didObserveURLBeacon(beaconScanner: SpotSense, URL: NSURL, RSSI: Int) {
        
    }
    
    let locationManager : CLLocationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    let spotsense = SpotSense(clientID: "s63HFHDdAUIDKnDdWCKWlcPORnTMvupH",
                              clientSecret: "3Q46H0d7oqMiCthFSoHt46KSRGxAZc6nEmluc6-_Ru8ngaZ-TFJnzfVwTre7QtYT")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get notification permission, only required if sending notifications with SpotSense
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            self.spotsense.notificationStatus(enabled: granted)
        }
        
        
        
        spotsense.delegate = self // attach spotsense delegate to self
//        spotsense.startScanning()
        
        if (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) { // Make sure region monitoring is supported.
                spotsense.getRules {}
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // spotsense delegate method that fires whenever a rule is triggered
    func ruleDidTrigger(response: NotifyResponse, ruleID: String) {
        if let segueID = response.segueID { // performs screenchange
            performSegue(withIdentifier: segueID, sender: nil)
        } else if (response.getActionType() == "http") {
            _ = response.getHTTPResponse()
        }
    }
    
//    // required so spotsense knows which geofences are being triggered
//    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
//        spotsense.handleRegionState(region: region, state: state)
//    }
//
//    // Not required: Prints which rules are being monitored for, helpful for debugging
//    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
//        print("Started monitoring for \(region.identifier)")
//    }

}

