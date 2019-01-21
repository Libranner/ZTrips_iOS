//
//  PlacesManager.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 19/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation
import UserNotifications

class PlacesManager {
  static let shared = PlacesManager()
  
  
  func setupInPlaceNotifications(context: NSManagedObjectContext) {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.removeAllPendingNotificationRequests()
    let req = Place.fetchRequest() as NSFetchRequest<Place>
    
    if let result = try? context.fetch(req), result.count > 0 {
      for place in result {
        //setting the notification
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "It looks like you are close to \(place.name!)"
        notificationContent.body = "Get more info about this place"
        notificationContent.sound = UNNotificationSound.default
        //notificationContent.userInfo = nil
        
        //setting the trigger with a location - unable to simulate
        if let coordinate = place.coordinate {
          let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
          let region = CLCircularRegion(center: center, radius: coordinate.radio * 1.5, identifier: UUID().uuidString)
          region.notifyOnEntry = true
          region.notifyOnExit = false
          
          let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)
          //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
          
          //setting the request
          let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString,
                                                          content: notificationContent, trigger: locationTrigger)
          //sending the notification
          notificationCenter.add(notificationRequest, withCompletionHandler: nil)
        }
      }
    }
  }
}
