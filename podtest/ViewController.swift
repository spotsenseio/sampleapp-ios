//
//  ViewController.swift
//  podtest
//
//  Created by Jonathan Reiss on 9/23/18.
//  Copyright © 2018 SpotSense. All rights reserved.
//

import UIKit
import SpotSense
import CoreLocation
import UserNotifications // required if sending notifications with SpotSense

let spotsense = SpotSense(clientID: "sample-client-id", clientSecret: "sample-client-secret") // replace these vlaues

class ViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, SpotSenseDelegate  {
    let locationManager : CLLocationManager = CLLocationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get notification permission, only required if sending notifications with SpotSense
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            spotsense.notificationStatus(enabled: granted);
        }
        
        // get location permissions
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        spotsense.delegate = self; // attach spotsense delegate to self
        
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
            let httpResponseBody = response.getHTTPResponse()
        }
    }
    
    // required so spotsense knows which geofences are being triggered
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        spotsense.handleRegionState(region: region, state: state)
    }
    
    // Not required: Prints which rules are being monitored for, helpful for debugging
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started monitoring for \(region.identifier)")
    }

}

