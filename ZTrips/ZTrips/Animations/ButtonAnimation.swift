//
//  ButtonAnimation.swift
//  ZTrips
//
//  Created by Clary Morla Gomez on 20/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    
    func pulseButton(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue =  0.95
        pulse.toValue = 1.0
        pulse.initialVelocity = 6
        pulse.damping = 0.5
        
        layer.add(pulse, forKey: nil)
    }
}
