//
//  ViewControllerAnimation.swift
//  ZTrips
//
//  Created by Clary Morla Gomez on 20/01/2019.
//  Copyright © 2019 Libranner Leonel Santos Espinal. All rights reserved.
//

//Esta es una animacion para los view controllers, usando la transicion, se deberia de llamar con los segue, pero....
//Este pedacito de codigo (see below) va en el ViewController que queremos animar, o en la parte de la transicion

//let viewAnimations = ViewAnimation()
//override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    let destination = segue.destination
//    destination.transitioningDelegate = viewAnimation
//}

import UIKit

class ViewAnimation: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duration = 1.0
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let container = transitionContext.containerView
        let screenOfUp = CGAffineTransform(translationX: 0, y: -container.frame.height)
        let screenOfDown = CGAffineTransform(translationX: 0, y: container.frame.height)
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        toView.transform = screenOfUp
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            fromView.transform = screenOfDown
            fromView.alpha = 0.5
            toView.transform = CGAffineTransform.identity
            toView.alpha = 1
            
        }) { (success) in
            transitionContext.completeTransition(success)
        }
        
        
    }
    
    
}



