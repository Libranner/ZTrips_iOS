//
//  AboutViewController.swift
//  ZTrips
//
//  Created by Clary Morla Gomez on 15/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    let viewAnimation = ViewAnimation()
    
    @IBOutlet var aboutView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Animation
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        aboutAnimate()
    }
    
    
    func aboutAnimate() {
        aboutView.transform = CGAffineTransform.init(translationX: 0, y: +view.bounds.size.height )
        aboutView.alpha = 0
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveLinear, animations: {
            self.aboutView.transform = CGAffineTransform.identity
            self.aboutView.alpha = 1
        }, completion: nil)
        
    }
    
}
