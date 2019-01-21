//
//  PlaceDetailViewController.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 16/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PlaceDetailViewController: UIViewController {

  var place: Place?

  @IBOutlet weak var mainImageView: AsyncImageView!
  @IBOutlet weak var placeNameLabel: UILabel!
  @IBOutlet weak var placeDescriptionLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var scheduleLabel: UILabel!
  @IBOutlet weak var removeButton: UIButton!
  @IBOutlet weak var typeLabel: UILabel!
  
  override func viewDidLoad() {
      super.viewDidLoad()
      setupScreen()
  }
  
  func setupScreen() {
    if let place = place {
      if place.isCustom {
        mainImageView.image = UIImage(contentsOfFile: place.mainImageUrl!.absoluteString)
      }
      else {
        mainImageView.fillWithURL(place.mainImageUrl!, placeholder: nil)
      }
      
      placeNameLabel.text = place.name
      placeDescriptionLabel.text = place.summary
      scheduleLabel.text = place.schedule
      typeLabel.text = " \(place.type ?? "") "
      
      
      if let coordinate = place.coordinate {
        let userLocation = LocationService.shared.lastLocation
        let location = CLLocation(latitude: coordinate.latitude,
                                  longitude: coordinate.longitude)
        
        if let userLocation = userLocation {
          let distance = userLocation.distance(from: location)
          locationLabel.text = "\(String(format: "%.2f", distance/1000)) km away"
        }
        else {
          locationLabel.text = "..."
        }
      }
      removeButton.isHidden = !place.isCustom
    }
  }
  
  @IBAction func openMap(_ sender: Any) {
    if let place = place, let coordinate = place.coordinate {
      let latitude:CLLocationDegrees =  coordinate.latitude
      let longitude:CLLocationDegrees =  coordinate.longitude
      
      let regionDistance:CLLocationDistance = 10000
      let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
      let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
      let options = [
        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
      ]
      let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = "\(place.name!)"
      mapItem.openInMaps(launchOptions: options)
    }
  }
  
  @IBAction func removeButtonTapped(_ sender: Any) {
    if let place = place {
      let vc = self.navigationController?.viewControllers[0] as! PlacesTableViewController
      let context = vc.managedObjectContext!
      context.delete(place)
      
      let name = place.name!
      
      do {
        try context.save()
        let alert = UIAlertController(title: "Place removed", message: "\(name) has been removed",
          preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: {
          self.navigationController?.popViewController(animated: true)
        })
      }
      catch {
        let alert = UIAlertController(title: "Error", message: "An error has ocurred trying to remove \(name)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
      }
    }
  }
}
