//
//  AboutViewController.swift
//  ZTrips
//
//  Created by Clary Morla Gomez on 15/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

  @IBOutlet var aboutView: UIView!
  @IBOutlet weak var mainStackView: UIStackView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        aboutAnimate()
    }
  
  //MARK: Animation
  func aboutAnimate() {
      mainStackView.transform = CGAffineTransform.init(translationX: 0, y: +view.bounds.size.height )
      mainStackView.alpha = 0
    
      UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveLinear, animations: {
          self.mainStackView.transform = CGAffineTransform.identity
          self.mainStackView.alpha = 1
      }, completion: nil)
  }
}
