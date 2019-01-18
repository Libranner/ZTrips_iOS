//
//  PlacesCollectionViewController.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 15/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PlacesCollectionViewController: UICollectionViewController {
  
  var places : [Place] = [Place]()
  
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let patternImage = UIImage(named: "Pattern") {
      view.backgroundColor = UIColor(patternImage: patternImage)
    }
    collectionView?.backgroundColor = UIColor.white
    collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)

    if let layout = collectionView?.collectionViewLayout as? CustomLayout {
      layout.delegate = self
    }
    
    DataDownloader().download { [weak self] (allPlaces) in
      self?.places = allPlaces!
      DispatchQueue.main.async {
        self?.collectionView?.reloadData()
      }
    }
  }
}

extension PlacesCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return places.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    if let annotateCell = cell as? PlaceCell {
      annotateCell.place = places[indexPath.item]
    }
    return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let place = getPlace(index: indexPath.item)
    print(" Place: \(place!.name)")
    
    self.performSegue(withIdentifier: SegueIdentifiers.PLACE_DETAIL, sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == SegueIdentifiers.PLACE_DETAIL) {
      let vc = segue.destination as! PlaceDetailViewController
      let place = getPlace(index: collectionView.indexPathsForSelectedItems!.first!.item)
      vc.place = place
    }
    else if(segue.identifier == SegueIdentifiers.PLACE_FILTERS) {
      guard let navigationController = segue.destination as? UINavigationController,
        let vc = navigationController.topViewController as? FiltersTableViewController else {
          return
      }
      vc.delegate = self
    }
  }
  
  fileprivate func getPlace(index: Int) -> Place? {
    if(index < places.count) {
      return places[index]
    }
    return nil
  }
}

extension PlacesCollectionViewController : CustomLayoutDelegate {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    
    if indexPath.item % 2 == 0 {
      return 300
    }
    else if indexPath.item % 3 == 0 {
      return 400
    }
    return 500
    //return places[indexPath.item].image.size.height
  }
}

extension PlacesCollectionViewController: FiltersTableViewControllerDelegate {
  func filtersController(_ controller: FiltersTableViewController, didSelectFilters filters: [String]) {
    //searchedTypes = controller.selectedTypes.sorted()
    dismiss(animated: true)
    //fetchNearbyPlaces(coordinate: mapView.camera.target)
  }
}
