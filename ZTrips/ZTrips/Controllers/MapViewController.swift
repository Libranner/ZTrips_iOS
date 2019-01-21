//
//  MapViewController.swift
//  ZTrips
//
//  Created by Clary Morla Gomez on 09/01/2019.
//  Copyright © 2019 Clary Morla Gomez. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
  var places: [Place]?
  var selectedPlace: Place?
  
  override func viewDidLoad() {
      super.viewDidLoad()
  }

  override func loadView() {
    if let userLocation = LocationService.shared.lastLocation?.coordinate {
      let camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude,
                                            longitude: userLocation.longitude, zoom: 13.0)
      let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
      mapView.delegate = self
      self.view = mapView
      mapView.settings.myLocationButton = true
      
      guard places != nil else {
        return
      }
      
      for place in places! {
        if let coordinate = place.coordinate {
          let location_marker = GMSMarker()
          location_marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                            longitude: coordinate.longitude)
          location_marker.title = place.name
          location_marker.snippet = "Hey, check out this place \(place.name!)"
          location_marker.tracksInfoWindowChanges = true
          location_marker.map = mapView
          location_marker.userData = place
        }
      }
    }
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    //AQUI HACES LO QUE QUIERAS HACER
    if let place = marker.userData as? Place {
      selectedPlace = place
      performSegue(withIdentifier: SegueIdentifiers.PLACE_DETAIL, sender: self)
    }
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard selectedPlace != nil else {
      return
    }
    
    let vc = segue.destination as! PlaceDetailViewController
    vc.place = selectedPlace
  }

}
