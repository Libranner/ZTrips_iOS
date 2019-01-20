//
//  ViewController.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 02/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class ViewController: UIViewController {

    let viewAnimation = ViewAnimation()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //MARK: Notifications
    
    //setting the notification
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "Saludos Terricola"
    notificationContent.body = "Check out this new place near you"
    notificationContent.sound = UNNotificationSound.default
    
    //setting the trigger with a timer
    let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    
    //setting the trigger with a location - unable to simulate
    
//    let center = CLLocationCoordinate2D(latitude: 37.335400, longitude: -122.009201)
//    let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "Headquarters")
//    region.notifyOnEntry = true
//    region.notifyOnExit = false
//    let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)

    
    //setting the request
    let notificationRequest = UNNotificationRequest(identifier: "ZaragozaTripsNotification", content: notificationContent, trigger: notificationTrigger)

    //sending the notification
    UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: nil)

    
    //MARK: DataDownloader
    
    DataDownloader().download { (places) in
      print(places!)
    }
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        destination.transitioningDelegate = viewAnimation
    }
}

