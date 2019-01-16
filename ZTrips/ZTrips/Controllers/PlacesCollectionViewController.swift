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
    collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 10, right: 0)
    // Set the PinterestLayout delegate
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
