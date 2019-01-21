//
//  MapViewController.swift
//  ZTrips
//
//  Created by Clary Morla Gomez on 09/01/2019.
//  Copyright © 2019 Clary Morla Gomez. All rights reserved.
//

import UIKit
import GoogleMaps

struct Location {
  let name: String
  let lat: CLLocationDegrees
  let lon: CLLocationDegrees
}

class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var theMap: GMSMapView!
    
    let viewAnimation = ViewAnimation() //next view transition animation
    
    override func viewDidLoad() {
      super.viewDidLoad()
        
  }
    
    //MARK: Setting the map
    
  let locations = [
    Location(name: "Huesca", lat: 42.133196, lon: -0.407785),
    Location(name: "Pamplona", lat: 42.812828, lon: -1.642914),
    Location(name: "Zuera", lat: 41.866303, lon: -0.790215)]

  override func loadView() {
    
    let camera = GMSCameraPosition.camera(withLatitude: 41.648695, longitude: -0.889543, zoom: 6.0)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    mapView.delegate = self
    self.view = mapView
    mapView.settings.myLocationButton = true
    mapView.animate(toZoom: 12.0)
    
    let zoomCamera = GMSCameraUpdate.zoomIn()
    mapView.animate(with: zoomCamera)
    mapView.settings.scrollGestures = true
    mapView.settings.zoomGestures   = true
    mapView.settings.rotateGestures = true
    
    
    //MARK: Animations ("crapy animation")
    
//    mapView.alpha = 0
//
//    let fromView = CGAffineTransform(translationX: 0, y: -1000)
//    let toView = CGAffineTransform(translationX: 0, y: +1000)
//    mapView.transform = fromView
//
//    UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseIn, animations: {
//        mapView.transform = toView
//        mapView.alpha = 1
//    }, completion: nil)
    

    //MARK: Marker
    
    for location in locations {
      let location_marker = GMSMarker()
      location_marker.position = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
      location_marker.title = location.name
      location_marker.snippet = "Hey, check out this place \(location.name)"
      location_marker.tracksInfoWindowChanges = true
      location_marker.map = mapView
    }
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    //AQUI HACES LO QUE QUIERAS HACER
    return true
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    let vc = segue.destination as! PlaceDetailViewController
//    vc.location_title = selectedTitle!
//    vc.transitioningDelegate = viewAnimation
  }
    
    
}
