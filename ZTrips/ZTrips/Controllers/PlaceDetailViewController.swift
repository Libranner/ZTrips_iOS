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

  @IBOutlet weak var removeButton: UIButton!
  @IBOutlet weak var mainImageView: AsyncImageView!
  @IBOutlet weak var placeNameLabel: UILabel!
  @IBOutlet weak var placeDescriptionLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var scheduleLabel: UILabel!
  @IBOutlet weak var navigateToButton: UIButton!

    
    override func viewDidLoad() {
      super.viewDidLoad()
      startLabelAnimation()
      startButtonAnimation()
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
    
    //MARK: Animations
    
    //Basic stuff:
    func fadeIn(view: UIView) {
        view.alpha = 1
    }
    
    func fadeOut(view: UIView){
        view.alpha = 0
    }
    
    //where the magic happens:
    func startLabelAnimation(){
        let duration: Double = 1.5
       
        placeNameLabel.alpha = 0
        placeDescriptionLabel.alpha = 0
        locationLabel.alpha = 0
        removeButton.alpha = 0
        scheduleLabel.alpha = 0
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.fadeIn(view: self.placeNameLabel)
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 1.0, options: .curveEaseIn, animations: {
            self.fadeIn(view: self.placeDescriptionLabel)
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.fadeIn(view: self.locationLabel)
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            self.fadeIn(view: self.scheduleLabel)
        }, completion: nil)
        
        UIView.animate(withDuration: duration, delay: 2.0, options: .curveLinear, animations: {
            self.fadeIn(view: self.removeButton)
        }, completion: nil)
        
    }
    
    func startButtonAnimation(){
        let duration: Double = 1.0
        
        navigateToButton.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        UIView.animate(withDuration: duration, delay: 1.0, options: .autoreverse, animations: {
            self.navigateToButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
}
