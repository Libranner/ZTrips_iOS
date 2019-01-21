//
//  LocationService.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 20/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
  var locationManager:CLLocationManager?
  var lastLocation:CLLocation?
  
  static let shared = LocationService()
  
  fileprivate override init() {
    super.init()
  }
  
  func start() {
    guard locationManager == nil else {
      return
    }
    locationManager = CLLocationManager()
    
    if let locationManager = locationManager {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestAlwaysAuthorization()
      
      if CLLocationManager.locationServicesEnabled() {
        locationManager.startUpdatingLocation()
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    lastLocation = locations[0] as CLLocation
    manager.stopUpdatingLocation()
  }
}
