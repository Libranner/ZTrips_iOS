//
//  PlaceDetailViewController.swift
//  ZTrips
//
//  Created by Libranner Leonel Santos Espinal on 16/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {

  var place: Place?

  @IBOutlet weak var mainImageView: AsyncImageView!
  @IBOutlet weak var placeNameLabel: UILabel!
  @IBOutlet weak var placeDescriptionLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var scheduleLabel: UILabel!
  
  override func viewDidLoad() {
      super.viewDidLoad()
      setupScreen()
  }
  
  func setupScreen() {
    if let place = place {
      mainImageView.fillWithURL(place.mainImageUrl, placeholder: nil)
      placeNameLabel.text = place.name
      placeDescriptionLabel.text = place.summary
      locationLabel.text = "23232"
      scheduleLabel.text = place.schedule
    }
  }
}
